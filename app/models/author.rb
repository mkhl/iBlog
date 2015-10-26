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

class Author < ActiveRecord::Base
  attr_accessible :handle, :name

  # Find or construct an appropriate author, given a handle
  def self.for_handle(handle)
    author = Author.find_by_handle(handle)
    if ! author
      author = Author.new(handle: handle, name: handle)
      author.save
    end
    author
  end
end
