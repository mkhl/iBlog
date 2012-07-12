class CommentsController < ApplicationController
  def create
    blog = Blog.find(params[:blog_id])
    entry = Entry.find(params[:entry_id])
    comment = entry.comments.new(params[:comment])

    if comment.save(params[:comment])
      flash[:success] = "Der Kommentar wurde gespeichert."
    else
      flash[:error] = "Der Kommentar konnte nicht gespeichert werden."
    end

    redirect_to blog_entry_url(blog, entry, :anchor => "comment-#{comment.id}")
  end

  def destroy
    comment = Comment.find(params[:id])
  end
end
