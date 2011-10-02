class ProjectsController < ApplicationController
  before_filter :authenticate
  def new
    @title = "New project"
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
    @features = @project.features.page(params[:page]).per(10)
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
    @project = Project.find(params[:id])
    @title = "Edit project"
  end

  def update
    @project = Project.find(params[:id])
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

end
