# encoding: UTF-8

class EntriesController < ApplicationController
  before_filter :set_user, :set_blog, :except => [ :home, :user_home ]

  def index
    @entries = Entry.where(:blog_id => @blog.id).order('id DESC').page(params[:page])
    if @blog
      @auto_discovery_url = blog_entries_path(@blog.id, :atom)
    elsif params[:tag]
      @auto_discovery_url = tag_path( params[:tag], :atom )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.html.erb
      format.xml  { render :xml => @entries }
    end
  end

  def full
    @entries = Entry.page(params[:page]).order('created_at DESC')
    respond_to do |format|
      format.atom # index.html.erb
    end
  end

  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  def new
#    @blog = Blog.find( params[:blog_id] )
    @entry = Entry.new(:author => @user, :blog_id => @blog.id, :title => "#{h(@user).capitalize}s PPP am #{ Date.today}")

    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def create
#    @blog = Blog.find( params[:blog_id] )

    @entry = Entry.new(params[:entry])
    @entry.author = @user
    @entry.blog_id = @blog.id
    respond_to do |format|
      if @entry.save
        flash[:notice] = 'Entry was successfully created.'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
      format.xml  { head :ok }
    end
  end

  def home
    redirect_to :action => 'user_home', :id => @user
  end

  def user_home
    @author = params[:author]
    @entries = Entry.page(params[:page]).where(:author => params[:author]).order('created_at DESC')
    @auto_discovery_url = user_home_path(@author, :atom)

    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'index' }
      format.xml  { render :xml => @entries }
    end

  end

  private
    def set_blog
      @blog = Blog.find(params[:blog_id])
    end

end
