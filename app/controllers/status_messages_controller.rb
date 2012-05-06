# encoding: UTF-8

class StatusMessagesController < ApplicationController

  def index
    @messages = StatusMessage.order("updated_at DESC").page(params[:page])
    render :text => @messages.map { |msg| "[#{msg.updated_at}] #{msg.author}: #{msg.body}" }.join("\n<hr>\n") # XXX: DEBUG
  end

  def create
    @msg = StatusMessage.new(params[:status_message])
    @msg.author = @user

    if @msg.save
      flash[:success] = "Die Nachricht wurde gespeichert."
       redirect_to status_messages_path
    else
      flash[:error] = "Die Nachricht konnte nicht gespeichert werden."
      render :action => "edit"
    end
  end

end
