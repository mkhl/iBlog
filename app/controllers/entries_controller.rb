# encoding: utf-8
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

class EntriesController < ApplicationController
  # before_filter :set_blog, :except => [ :home, :user_home, :full, :by_author, :by_tag ]

  def index
    @blog = Blog.find(params[:blog_id])
    @entries = Entry.where(:blog_id => @blog.id).order('entries.id DESC')
    respond_to do |format|
      format.html { @entries = @entries.page(params[:page]) }
      format.atom
      format.xml  { render :xml => @entries }
    end
  end

  def full
    @entries = Entry.page(params[:page]).order('id DESC')
    respond_to do |format|
      format.html { render :index }
      format.atom { render :index }
    end
  end

  def by_author
    @entries = Entry.includes(:author).where('authors.handle = ?', params[:author]).references(:author).order('entries.id DESC')
    respond_to do |format|
      format.html do
        @entries = @entries.page(params[:page])
        render :index
      end
      format.atom { render :index }
    end
  end

  def by_tag
    @entries = Entry.tagged_with(params[:tag]).by_date
    respond_to do |format|
      format.html do
        @entries = @entries.page(params[:page])
        render :index
      end
      format.atom { render :index }
    end
  end

  def show
    @entry = Entry.includes(:blog, :comments, :tags)
                  .references(:blog, :comments, :tags)
                  .find(params[:id])

    @blog = @entry.blog
    @edit_comment = @entry.comments.new
    @comments = @entry.comments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  def new
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
    end

    @entry = Entry.new do |entry|
      entry.author = Author.for_handle @user
      entry.blog_id = @blog.id if @blog
      entry.title = "PPP von #{entry.author.name} am #{Date.today}"
    end

    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def create
    if params[:entry] && params[:entry][:blog_id].present?
      @blog = Blog.find(params[:entry][:blog_id])
    end

    params[:entry].delete(:blog_id)

    @entry = Entry.new(params[:entry])
    @entry.author = @author
    @entry.blog = @blog

    respond_to do |format|
      if params[:commit] == "Vorschau"
        @entry.regenerate_html
        @preview = true
        format.html { render :action => "edit" }
      else
        if @entry.save
          flash[:success] = 'Der Eintrag wurde gespeichert.'
          format.html { redirect_to blog_entry_url(@blog, @entry) }
          format.xml  { render :xml => @entry, :status => :created, :location => @entry }
        else
          flash[:error] = 'Der Eintrag konnte nicht gespeichert werden.'
          format.html { render :action => "edit" }
          format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.owned_by? @user
      respond_to do |format|
        if params[:commit] == "Vorschau"
          @entry.assign_attributes(params[:entry])
          @entry.regenerate_html
          @preview = true
          format.html { render :action => "edit" }
        else
          if @entry.update_attributes(params[:entry])
            flash[:success] = 'Der Eintrag wurde gespeichert.'
            format.html { redirect_to blog_entry_url(@entry.blog, @entry) }
            format.xml  { head :ok }
          else
            flash[:error] = 'Der Eintrag konnte nicht gespeichert werden.'
            format.html { render :action => "edit" }
            format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
          end
        end
      end
    else
      head :unauthorized
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    if @entry.owned_by? @user
      @entry.destroy
      flash[:notice] = 'Der Eintrag wurde gelöscht.'
      respond_to do |format|
        format.html { redirect_to blog_entries_url(@entry.blog) }
        format.xml  { head :ok }
      end
    else
      # The user was clever enough to rig up this request
      # without aid of our UI,
      # so he might be clever enough to interpret the answer
      # without UI aid as well.
      head :unauthorized
    end
  end

  def home
    redirect_to :action => 'user_home', :id => @user
  end

  def user_home
    @author = Author.for_handle params[:author]
    @entries = Entry.page(params[:page]).where('author_id = ?', @author.id).order('entries.id DESC')

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'index' }
      format.xml  { render :xml => @entries }
    end
  end
end
