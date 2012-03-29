class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def set_user
      @user = request.headers['REMOTE_USER'] || 'guest'
    end
end
