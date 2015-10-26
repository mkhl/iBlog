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
  before_action :sync_authors

  protected

  def sync_authors
    AuthorSync.start if Random.rand > 0.8 # no need to check every time
  end

  def set_user
    @user = request.headers['REMOTE_USER'] || 'rumpelxyz'
  end

  def set_author
    @author = Author.find_by_handle(@user)
    if ! @author
      @author = Author.new(handle: @user, name: @user)
      @author.save
    end
  end
end
