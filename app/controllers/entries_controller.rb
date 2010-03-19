class EntriesController < ApplicationController
  before_filter :set_user
  
  # GET /entries
  # GET /entries.xml
  def index
    #todo why to the the next five lines have to be so ugly?
    options = { :page => params[:page], :order => 'created_at DESC' }
    author = params[:author]
    if !author.nil? 
      options.merge! :conditions => [ "author = ?",  author]
    end
    @entries = Entry.paginate(options)
    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.html.erb
      format.xml  { render :xml => @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry = Entry.new(:author => @user, :title => "#{h(@user).capitalize}s PPP am #{ Date.today}")

    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.xml
  def create
    @entry = Entry.new(params[:entry])
    @entry.author = @user
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

  # PUT /entries/1
  # PUT /entries/1.xml
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

  # DELETE /entries/1
  # DELETE /entries/1.xml
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
    
  end

private
  def set_user
    @user = request.headers['REMOTE_USER'] || 'guest'
  end
end
