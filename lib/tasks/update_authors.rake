# encoding: UTF-8
# Copyright 2015 innoQ Deutschland GmbH

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Retrieves the authors list from a predefined URI
# puts any new authors (by handle) into the database
# and updates all authors' name and avatar info.

namespace :authors do
  desc "Updates author names and avatars in DB. Required argument list_uri, optional username and passwd."
  task :update, [:list_uri, :username, :passwd] => [ :environment ] do |t, args|
    puts "have '#{args.list_uri}' for '#{args.username}' with '#{args.passwd}'"
    list_uri = args.list_uri
    username = args.username
    passwd = args.passwd
    if ! list_uri
      raise "ERROR: Required task argument list_uri missing."
    end

    # Retrieve external author list.
    incoming_list = retrieve_incoming_list(list_uri, username, passwd)

    # Retrieve what we have in the database, as a map.
    handle2author = {}
    Author.all.each do |author|
      handle2author[author.handle.downcase] = author
    end

    # See to it all names from external list are in the database.
    # (This never removes any records from the database no longer
    # in the external list.)
    yield_handles_and_names_and_avatar(incoming_list) do |handle, name, avatar_uri|
      # Beware: MySQL often treats upper and lower case as identical, for sorting and equality.
      if author = handle2author[handle.downcase]
        if author.name != name || author.avatar_uri != avatar_uri
          author.update(name: name, avatar_uri: avatar_uri)
        end
      else
        author = Author.new(handle: handle.downcase, name: name, avatar_uri: avatar_uri)
        # Treat dupes in list (last entry wins):
        handle2author[handle.downcase] = author
        author.save
      end
    end
  end

  # Encapsulate how to retrieve handle and name
  # out of the incoming list structure derived from JSON.
  def yield_handles_and_names_and_avatar(incoming_list)
    incoming_list["members"].each do |handle, details|
      name = details["displayName"]
      if name
        # TODO: Make this useable outside innoQ context.
        avatar_uri_raw = details["avatar"]
        avatar_uri = avatar_uri_raw ? "https://intern.innoq.com#{avatar_uri_raw}/64x64" : nil
        yield handle, name, avatar_uri
      end
    end
  end

  # Retrieve the incoming list and
  # parse the JSON format.
  def retrieve_incoming_list(uri_raw, username, passwd)
    uri = URI.parse(uri_raw)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth(username, passwd) if username && passwd

    http.read_timeout = 10 # seconds
    res = http.request(req)
    if res.kind_of? Net::HTTPSuccess
      JSON.parse res.body
    else
      raise "Could not retrieve #{uri_raw} (as user \"#{username}\"): #{res.code}: #{res.message}"
    end
  end
end
