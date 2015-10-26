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

require "net/http"
require "uri"

# Class for synchronising our authors' names from some
# external resource providing a JSON response.

class AuthorSync

  def self.start
    uri = ENV["IBLOG_AUTHORLIST_URI"]

    # If source is not configured, do nothing:
    return false unless uri

    username = ENV["IBLOG_AUTHORLIST_USERNAME"]
    password = ENV["IBLOG_AUTHORLIST_PASSWORD"]

    # use meta author to store timestamp of last sync - hacky, but effective
    meta_handle = "$LAST_SYNC$"
    meta_author = Author.select("id", "updated_at").find_by_handle(meta_handle)
    if meta_author
      # Do at most once in three hours:
      return unless (Time.now - meta_author.updated_at) > 3600 * 3
    else
      meta_author = Author.create(handle: meta_handle, name: meta_handle)
    end

    # Retrieve external author list
    incoming_list = retrieve_incoming_list(uri, username, password)
    return false unless incoming_list

    # Retrieve what we have in the database, as a map
    handle2author = Author.select("id", "handle", "name").inject({}) do |memo, author|
      memo[author.handle] = author
      memo
    end

    # See to it all names from external list are in the database.
    # (This never removes any records from the database no longer
    # in the external list.)
    yield_handles_and_names(incoming_list) do |handle, name|
      if author = handle2author[handle]
        if author.name != name
          author.update(name: name)
        end
      else
        Author.new(handle: handle, name: name).save
      end
    end

    meta_author.touch
  end

  # Encapsulate how to retrieve handle and name
  # out of the incoming list structure derived from JSON.
  def self.yield_handles_and_names(incoming_list)
    incoming_list["members"].each do |handle, details|
      name = details["displayName"]
      yield handle, name if name
    end
  end

  # Retrieve the incoming list and
  # parse the JSON format.
  def self.retrieve_incoming_list(uri_raw, username, password)
    uri = URI.parse(uri_raw)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth(username, password) if username && password

    http.read_timeout = 10 # seconds
    begin
      res = http.request(req)
      return res.kind_of?(Net::HTTPSuccess) ? JSON.parse(res.body) : nil
    rescue
      return nil
    end
  end
end
