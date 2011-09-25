class ProjectsController < ApplicationController
  def new
    @title = "New project"
    @project = Project.new
  end

  def index
    @title = "Projects"
    @projects = Project.page(params[:page]).per(10)
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

end
