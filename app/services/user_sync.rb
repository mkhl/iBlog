# encoding: UTF-8
# Copyright 2014 innoQ Deutschland GmbH

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

class UserSync

  def self.start
    url = ENV["IBLOG_USERLIST_URL"]
    return false unless url
    username = ENV["IBLOG_USERLIST_USERNAME"]
    password = ENV["IBLOG_USERLIST_PASSWORD"]

    # use meta user to store timestamp of last sync - hacky, but effective
    meta_handle = "LAST_SYNC"
    meta_user = User.select("id", "updated_at").find_by_handle(meta_handle)
    if meta_user
      return unless (Time.now - meta_user.updated_at) / 3600 > 3 # every three hours
    else
      meta_user = User.create(handle: meta_handle)
    end

    userlist = retrieve(url, username, password)
    return false unless userlist

    users = User.select("id", "handle", "name").inject({}) do |memo, user|
      memo[user.handle] = user
      memo
    end

    transform(userlist) do |handle, name|
      user = users[handle] || User.new(handle: handle)
      user.update(name: name) # XXX: inefficient; use bulk transaction?
    end

    meta_user.touch
  end

  def self.transform(userlist)
    userlist["members"].each do |username, details|
      name = details["displayName"]
      yield username, name if name
    end
  end

  def self.retrieve(url, username, password)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"

    req = Net::HTTP::Get.new(uri.request_uri)
    req.basic_auth(username, password) if username && password

    http.read_timeout = 1
    begin
      res = http.request(req)
      return JSON.parse(res.body)
    rescue
      return nil
    end
  end

end
