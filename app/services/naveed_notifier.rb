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

class NaveedNotifier

  def self.dispatch(sender, recipients, subject, body)
    naveed = ENV["IBLOG_NAVEED_URI"]

    # Deprecated, remove when changed on production host:
    naveed = ENV["IBLOG_NAVEED_URL"] unless naveed

    token = ENV["IBLOG_NAVEED_TOKEN"]
    return false unless naveed && token

    naveed = URI.parse(naveed)
    http = Net::HTTP.new(naveed.host, naveed.port)
    http.use_ssl = true if naveed.scheme == "https"

    req = Net::HTTP::Post.new(naveed.request_uri)
    req.add_field("Authorization", "Bearer #{token}")
    req.set_form_data({
      "sender" => sender,
      "recipient" => recipients,
      "subject" => subject,
      "body" => body
    })

    http.read_timeout = 1
    res = http.request(req) rescue nil
    return res.try(:code) == "202"
  end

end
