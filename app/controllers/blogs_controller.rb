# encoding: UTF-8

class BlogsController < ApplicationController

  before_filter :set_user

  def index
    @blogs = if params[:owner]
      Blog.where(:owner => params[:owner])
    else
      Blog.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.atom
      format.xml  { render :xml => @blogs }
    end
  end

  def show
    @blog = Blog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  def new
    @blog = Blog.new
    @blog.owner = @user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:success] = 'Das Blog wurde gespeichert.'
        format.html { redirect_to blog_entries_path(@blog) }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        flash[:error] = 'Das Blog konnte nicht gespeichert werden.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:success] = 'Das Blog wurde gespeichert.'
        format.html { redirect_to blog_entries_path(@blog) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Das Blog konnte nicht gespeichert werden.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    flash[:notice] = 'Das Blog wurde gelöscht.'

    respond_to do |format|
      format.html { redirect_to(blogs_url) }
      format.xml  { head :ok }
    end
  end
end
