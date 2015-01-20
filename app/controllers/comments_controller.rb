# encoding: UTF-8
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
class CommentsController < ApplicationController
  def index
    ## TODO
    # Feeds for: blog comments, entry comments
    @comments = Comment.where(nil)

    respond_to do |format|
      format.html do
        @comments = @comments.order("id DESC")
        if @author = params[:author]
          @comments = @comments.where(:author => params[:author])
          render "comments/index/by_author"
        else
          @comments = @comments.page(params[:page]).per(40)
          render "comments/index/all"
        end
      end
      format.atom do
        @comments = @comments.
          where(:updated_at => 40.days.ago.to_date..Date.tomorrow).
          order("id ASC")
      end
    end
  end

  def edit
    @edit_comment = Comment.find(params[:id])

    if @edit_comment.owner.is_a?(Entry)
      @entry = @edit_comment.owner
      @blog = @entry.blog
      @comments = @entry.comments
      tpl = 'entries/show'
    elsif @edit_comment.owner.is_a?(WeeklyStatus)
      @status = @edit_comment.owner
      @comments = @status.comments
      tpl = 'weekly_statuses/show'
    end

    render tpl
  end

  def update
    @edit_comment = Comment.find(params[:id])

    anchor = "comment-#{@edit_comment.id}"

    if @edit_comment.owner.is_a?(Entry)
      @entry = @edit_comment.owner
      @blog = @entry.blog
      tpl = 'entries/show'
      back_to = return_path(@entry, @edit_comment)
    elsif @edit_comment.owner.is_a?(WeeklyStatus)
      @status = @edit_comment.owner
      tpl = 'weekly_statuses/show'
      back_to = return_path(@status, @edit_comment)
    end

    if @edit_comment.owned_by?(@user)
      @edit_comment.content = params[:comment][:content]
      if params[:commit] == "Kommentar ändern"
        @edit_comment.save
        redirect_to back_to
      else
        # Preview only
        @edit_comment.regenerate_html
        @comments = @edit_comment.owner.comments
        @comment_preview = 1
        render tpl
      end
    else
      # The user was clever enough to rig up this request
      # without aid of our UI,
      # so he might be clever enough to interpret the answer
      # without UI aid as well.
      head :unauthorized
    end
  end

  def create
    owner = if params[:entry_id]
      Entry.find(params[:entry_id])
    elsif params[:weekly_status_id]
      WeeklyStatus.find(params[:weekly_status_id])
    else
      raise "no owner given"
    end

    comment = owner.comments.new(:content => params[:comment][:content])
    comment.author = @user

    if params[:commit] == "Vorschau"
      comment.regenerate_html
      @comments = owner.comments
      @comment_preview = 1
      @edit_comment = comment
      if owner.is_a?(Entry)
        @blog = owner.blog
        @entry = owner
        render 'entries/show'
      elsif owner.is_a?(WeeklyStatus)
        @status = owner
        render 'weekly_statuses/show'
      end
    else
      if comment.save
        flash[:success] = "Der Kommentar wurde gespeichert."
        notify(comment, owner) # NB: no notifications for edits
      else
        flash[:error] = "Der Kommentar konnte nicht gespeichert werden."
      end

      redirect_to return_path(owner, comment)
    end
  end

  def destroy
    comment = Comment.find(params[:id])

    if comment.owned_by?(@user)
      comment.destroy
      redirect_to return_path(comment.owner)
    else
      # The user was clever enough to rig up this request
      # without aid of our UI,
      # so he might be clever enough to interpret the answer
      # without UI aid as well.
      head :unauthorized
    end
  end

  private
  def notify(comment, owner)
    author = comment.author
    comments = owner.comments.select([:author, :content]) # XXX: inefficient

    commenters = comments.map(&:author)
    users = [owner.author].concat(commenters).uniq
    users.delete(author)

    preceding_comment = comments[-2]

    if owner.is_a?(Entry)
      subject = owner.title
      url = blog_entry_url(owner.blog, owner, anchor: "comment-#{comment.id}")
    elsif owner.is_a?(WeeklyStatus)
      subject = "Wochenstatus von #{owner.author}"
      url = weekly_status_url(owner, anchor: "comment-#{comment.id}")
    end

    body = <<-EOS
neuer Kommentar von #{author}:
"""
#{comment.content}
"""
#{url}
    EOS

    body += <<-EOS if preceding_comment
\nvorhergehender Kommentar von #{preceding_comment.author}:
"""
#{preceding_comment.content}
"""
    EOS

    Notifier.dispatch(author, users, "[iBlog] #{subject}", body)
  end

  def return_path(owner, comment = nil)
    anchor = "comment-#{comment.id}" if comment

    if owner.is_a?(Entry)
      blog_entry_url(owner.blog, owner, :anchor => anchor)
    elsif owner.is_a?(WeeklyStatus)
      weekly_status_path(owner, :anchor => anchor)
    end
  end
end
