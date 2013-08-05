class WeeklyStatusesController < ApplicationController
  def index
    @statuses = WeeklyStatus.page(params[:page])

    respond_to do |format|
      format.html
      format.atom
    end
  end

  def by_author
    @statuses = WeeklyStatus.where(:author => params[:author]).order('id DESC')

    respond_to do |format|
      format.html do
        @statuses = @statuses.page(params[:page])
        render :index
      end
      format.atom { render :index }
    end
  end

  def show
    @status = WeeklyStatus.find(params[:id])
    @edit_comment = @status.comments.new
    @comments = @status.comments
  end

  def new
    @status = WeeklyStatus.new do |s|
      s.author = @user
    end

    render :edit
  end

  def create
    @status = WeeklyStatus.new(params[:weekly_status])
    @status.author = @user
    if params[:commit] == "Vorschau"
      @status.regenerate_html
      @preview = true
      render :edit
    elsif @status.save
      flash[:success] = "Der Eintrag wurde gespeichert."
      redirect_to weekly_statuses_path
    else
      flash[:error] = "Der Eintrag konnte nicht gespeichert werden."
      render :edit
    end
  end

  def edit
    @status = WeeklyStatus.find(params[:id])
  end

  def update
    @status = WeeklyStatus.find(params[:id])
    if params[:commit] == "Vorschau"
      @status.assign_attributes(params[:weekly_status])
      @status.regenerate_html
      @preview = true
      render :edit
    elsif @status.update_attributes(params[:weekly_status])
      flash[:success] = "Der Eintrag wurde geändert."
      redirect_to weekly_statuses_path
    else
      flash[:error] = "Der Eintrag konnte nicht geändert werden."
      render :edit
    end
  end

  def destroy
    @status = WeeklyStatus.find(params[:id])
    if @status.owned_by?(@user) && @status.destroy
      flash[:success] = "Der Eintrag wurde gelöscht."
    else
      flash[:error] = "Der Eintrag konnte nicht gelöscht werden."
    end

    redirect_to weekly_statuses_path
  end
end
