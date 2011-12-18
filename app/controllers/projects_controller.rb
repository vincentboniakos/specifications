# coding: utf-8
class ProjectsController < ApplicationController
  include ProjectsHelper
  before_filter :authenticate
  before_filter :get_project, :only => ["show","edit","update"]
  add_crumb "Projects", :root_path
  def new
    add_crumb "New"
    @title = "New project"
    @project = Project.new
  end

  def show
    add_crumb @project.name
    @title = @project.name
    @title_header = project_show_title
    @features = @project.features
    @actions = add_feature_action
    @nav = nav_features
    @userstory = Userstory.new
    @versions = Version.all(:conditions => ['project_id = ?', @project.id], :order => "created_at DESC")
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:success] = "Your project has been created successfully."
      redirect_to @project
    else
      @title = "New project"
      render "new"
    end
  end

  def edit
    add_crumb @project.name, project_path(@project)
    add_crumb "Edit"
    @title = "Edit project"
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated."
      redirect_to @project
    else
      @title = "Edit project"
      render 'edit'
    end
  end
  
  def destroy
    Project.find(params[:id]).destroy
    flash[:succes] = "Project destroyed."
    redirect_to root_path
  end
  
  private 
    def get_project
      @project = Project.find(params[:id])
    end

end
