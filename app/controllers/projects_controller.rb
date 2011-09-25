class ProjectsController < ApplicationController
  def new
    @title = "New project"
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
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

end
