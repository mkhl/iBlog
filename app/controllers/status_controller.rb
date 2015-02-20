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
class StatusController < ApplicationController
  def index
    @headers = request.headers
    ["HTTP_AUTHORIZATION", "action_dispatch.secret_key_base", "action_dispatch.secret_token", "PASSENGER_CONNECT_PASSWORD"].each do |k|
      @headers[k] = "*REMOVED*" if @headers[k].present?
    end
    @log = `tail -n 50 #{Rails.root.join('log', "#{Rails.env}.log")}`
  end
end
