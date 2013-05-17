# Copyright 2013 innoQ Deutschland GmbH

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# encoding: UTF-8
class CommentsController < ApplicationController
  def index
    ## TODO
    # Feeds for: blog comments, entry comments
    @comments = Comment.includes(:entry => :blog).
        where(:updated_at => 40.days.ago.to_date..Date.tomorrow)

    respond_to do |format|
      format.html do
        @comments = @comments.order("id DESC")
        if @author = params[:author]
          @comments = @comments.where(:author => params[:author])
          render "comments/index/by_author"
        else
          render "comments/index/all"
        end
      end
      format.atom do
        @comments = @comments.order("id ASC")
      end
    end
  end

  def edit
    @edit_comment = Comment.find(params[:id])
    @entry = @edit_comment.entry
    @comments = @entry.comments
    @blot = @entry.blog
    render 'entries/show'
  end

  def update
    @edit_comment = Comment.find(params[:id])
    @entry = @edit_comment.entry
    @blog = @entry.blog
    if @edit_comment.owned_by?(@user)
      @edit_comment.content = params[:comment][:content]
      if params[:commit] == "Kommentar ändern"
        @edit_comment.save
        redirect_to blog_entry_url(@blog, @entry, :anchor => "comment-#{@edit_comment.id}")
      else
        # Preview only
        @edit_comment.regenerate_html
        @comments = @entry.comments
        @comment_preview = 1
        render 'entries/show'
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
    entry = Entry.find(params[:entry_id])
    blog = entry.blog
    comment = entry.comments.new(:content => params[:comment][:content])
    comment.author = @user

    if params[:commit] == "Vorschau"
      comment.regenerate_html
      @edit_comment = comment
      @blog = blog
      @entry = entry
      @comments = entry.comments
      @comment_preview = 1
      render 'entries/show'
    else
      if comment.save
        flash[:success] = "Der Kommentar wurde gespeichert."
      else
        flash[:error] = "Der Kommentar konnte nicht gespeichert werden."
      end
      redirect_to blog_entry_url(blog, entry, :anchor => "comment-#{comment.id}")
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    entry = comment.entry
    blog = entry.blog
    if comment.owned_by?(@user)
      comment.destroy
      redirect_to blog_entry_url(blog, entry)
    else
      # The user was clever enough to rig up this request
      # without aid of our UI,
      # so he might be clever enough to interpret the answer
      # without UI aid as well.
      head :unauthorized
    end
  end
end
