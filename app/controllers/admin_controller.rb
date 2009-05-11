class AdminController < ApplicationController
  def index
  end

  def log
    if params[:lines].nil?
      @lines = 10
    else
      @lines = params[:lines].to_i
    end
    @log = ''
    File.open(File.join(RAILS_ROOT, "log/#{RAILS_ENV}.log")) do |f|
      f.readlines[-@lines, @lines].each do |line|
        @log << line
      end
    end 
  end 
  
  def env       
    @request = request
  end

end
