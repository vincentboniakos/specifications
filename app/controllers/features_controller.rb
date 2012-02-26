# coding: utf-8
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
    @userstories = @feature.userstories
    @userstory = Userstory.new
  end

  def create
    @project = Project.find(params[:project_id])
    @feature = @project.features.build(params[:feature])
    @feature.position = 0
    if @feature.save
      flash[:success] = "Your feature has been created successfully. #{undo_link}"
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
      flash[:success] = "Feature updated. #{undo_link}"
      redirect_to @project
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

  def sort
    @project = Project.find(params[:project_id])
    @project.features.each do |feature|
      feature.position = params["#{feature.id}"]
      feature.save
    end
    render :nothing => true
  end

  private

  def breadcrumb
    @project = Project.find(params[:project_id])
    add_crumb @project.name.force_encoding(Encoding::UTF_8), project_path(@project)
  end
  
  def undo_link
    view_context.link_to("undo", revert_version_path(@feature.versions.scoped.last), :method => :post)
  end
end
