# coding: utf-8
class ProjectsController < ApplicationController
  include ProjectsHelper
  before_filter :get_project, :only => ["show","edit","update", "activity"]
  before_filter :authenticate
  
  def index
    @title = "Your projects"
    @projects = Project.joins(:stakeholders).where("user_id = ?",current_user.id).page(params[:page]).per(10) if signed_in?
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end

  end


  def show
    respond_to do |format|
      format.json { render json: @project }
    end 
  end

  def create
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        @project.stakeholders.create!(:user_id => current_user.id)
        format.json { render json: @project, status: :created, location: @project }
      else
        format.json {render json: @project.errors, status: :unprocessable_entity}
      end
    end
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
  
  def activity
    @versions = get_versions @project
    respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => @versions, :layout => false, :status => :accepted
          else
            redirect_to @project
          end
        end
      end
  end
  
  private 
    def get_project
      @project = Project.find(params[:id])
      if signed_in?
        if !@project.users.find_by_id(current_user.id)
          flash[:error] = "You are not authorized to access this resource."
          redirect_to root_path, :error => "You are not authorized to access to this resource."
        end
      end
    end

    def get_versions project
      Version.where('project_id = ?', project.id).order("created_at DESC").page(params[:page]).per(10)
    end


end
