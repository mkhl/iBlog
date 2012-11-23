# -*- coding: utf-8 -*-
class CommentsController < ApplicationController
  def index
    ## TODO
    # Feeds for: blog comments, entry comments
    @comments = Comment.includes(:entry => :blog)

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

  def create
    blog = Blog.find(params[:blog_id])
    entry = Entry.find(params[:entry_id])
    comment = entry.comments.new(params[:comment])
    comment.author = @user

    if comment.save(params[:comment])
      flash[:success] = "Der Kommentar wurde gespeichert."
    else
      flash[:error] = "Der Kommentar konnte nicht gespeichert werden."
    end
    redirect_to blog_entry_url(blog, entry, :anchor => "comment-#{comment.id}")
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
