require 'rails'
require 'mysql2'
require 'jquery-rails'
require 'kaminari'
require 'kaminari-i18n'
require 'rails-i18n'
require 'redcarpet'
require 'simple_form'
require 'protected_attributes'
require 'sass-rails'
require 'bootstrap-sass'
require 'uglifier'
require 'therubyracer'
require 'coffee-rails'

module Iblog
  class Engine < ::Rails::Engine

    initializer 'load_migrations' do |app|
      # load migrations into host applications
      app.config.paths['db/migrate'].concat(Iblog::Engine.paths['db/migrate'].existent)
    end

  end
end
