class FeaturesController < ApplicationController
  include FeaturesHelper
  add_crumb "Projects", :root_path
  before_filter :authenticate
  before_filter :breadcrumb, :only => ["show","edit","new","userstories"]
  
  
  def new
    add_crumb "New feature"
    @title = "New feature"
    @feature = Feature.new
  end

  def show
    @feature = Feature.find(params[:id])
    add_crumb @feature.name
    @title = @feature.name
    @title_header = feature_show_title
    @userstories = @feature.userstories
    @userstory = Userstory.new
  end

  def create
    @project = Project.find(params[:project_id])
    @feature = @project.features.build(params[:feature])
    if @feature.save
      flash[:success] = "Your feature has been created successfully."
      redirect_to project_path(@project)
    else
      @title = "New feature"
      render "new"
    end
  end

  def edit
    @feature = Feature.find(params[:id])
    add_crumb @feature.name, project_feature_path(@project,@feature)
    add_crumb "Edit"
    @title = "Edit feature"
  end

  def update
    @project = Project.find(params[:project_id])
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      flash[:success] = "Feature updated."
      redirect_to project_feature_path(@project,@feature)
    else
      @title = "Edit feature"
      render 'edit'
    end
  end
  
  def destroy
    @feature = Feature.find(params[:id])
    @project = @feature.project
    @feature.destroy
    flash[:succes] = "Feature destroyed."
    redirect_to @project
  end
  
  def userstories
    @feature = Feature.find(params[:id])
    @userstories = @feature.userstories
    @userstory = @feature.userstories.build(params[:userstory])
    if @userstory.save
      flash[:success] = "Your user story has been created successfully."
      redirect_to project_feature_path(@feature.project,@feature)
    else
      add_crumb @feature.name
      @title = @feature.name
      @title_header = feature_show_title
      render "show"
    end
  end
  
  private

    def breadcrumb
       @project = Project.find(params[:project_id])
       add_crumb @project.name, project_path(@project)
    end
end
