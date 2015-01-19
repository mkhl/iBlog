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
require File.expand_path('test_helper', File.dirname(__FILE__))
require 'capybara/rails'
require 'capybara/dsl'

module ActionDispatch
  class IntegrationTest
  include Capybara::DSL

    def assert_element(type, text, options={})
      ctx = options[:context] ? page.find(options[:context]) : page
      meth = {
        :content => :has_content?,
        :link => :has_link?,
        :button => :has_button?,
        :field => :has_field?,
        :select => :has_select?,
        :table => :has_table,
        :checked_field => :has_checked_field?
        }[type]
        raise "Unknown element type #{type.inspect}" unless meth
        assert(ctx.send(meth, text),
        options[:message] || "#{type.to_s.humanize} '#{text}' could not be found")
    end

    # options[:context] is an optional selector to limit scope
    # options[:message] is an optional error message
    def assert_content(text, options={})
      assert_element(:content, text, options)
    end

  end
end
