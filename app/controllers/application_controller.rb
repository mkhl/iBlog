# Copyright 2014, 2015 innoQ Deutschland GmbH

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_user
  before_action :set_author, only: [:new, :create, :update]

  protected

  def set_user
    user = request.headers['REMOTE_USER']
    # MySQL does not distinguish between upper and lower case.
    # For sanity, cast everything to lower case here.
    # (Well... Unfortunately, this casts only in the ASCII range.)
    @user = user.present? ? user.downcase : 'guest'
  end

  def set_author
    @author = Author.for_handle(@user)
  end
end
