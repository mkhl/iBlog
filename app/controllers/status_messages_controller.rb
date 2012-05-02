# encoding: UTF-8

class StatusMessagesController < ApplicationController

  def index
    @messages = StatusMessage.order('updated_at DESC').page(params[:page])
    render :text => @messages.map { |msg| "[#{msg.updated_at}] #{msg.author}: #{msg.body}" }.join("\n<hr>\n") # XXX: DEBUG
  end

  def create
    @msg = StatusMessage.new(params[:status_message])
    @msg.author = @user
    respond_to do |format|
      if @msg.save
        flash[:success] = 'Die Nachricht wurde gespeichert.'
        format.html { redirect_to status_messages_path }
        format.xml  { render :xml => @msg, :status => :created, :location => @msg }
      else
        flash[:error] = 'Die Nachricht konnte nicht gespeichert werden.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @msg.errors, :status => :unprocessable_entity }
      end
    end
  end

end
