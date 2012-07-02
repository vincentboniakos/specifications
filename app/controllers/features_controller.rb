# coding: utf-8
class FeaturesController < ApplicationController
  include FeaturesHelper
  add_crumb "Projects", :root_path
  before_filter :authenticate
  before_filter :get_project
  before_filter :is_stakeholder
  before_filter :breadcrumb, :only => ["show","edit","new","userstories"]


  def new
    add_crumb "New feature"
    @title = "New feature"
    @feature = Feature.new
  end
  
  def index
    @features = @project.features
    respond_to do |format|
      format.json { render json: @features }
    end
  end
    

  def show
    @feature = Feature.find(params[:id])
    respond_to do |format|
      format.html {
        add_crumb @feature.name
        @title = @feature.name
        @userstories = @feature.userstories
        @userstory = Userstory.new
      }
      format.json {render json: @feature}
    end

    add_crumb @feature.name
    @title = @feature.name
    @userstories = @feature.userstories
    @userstory = Userstory.new
  end

  def create
    @feature = @project.features.build(params[:feature])
    @feature.position = 0
    if @feature.save
      respond_to do |format|
        format.html {
          flash[:success] = "Your feature has been created successfully. #{undo_link}"
          redirect_to project_path(@project)
        }
        format.json {
          render json: @feature, status: :created, location: "##{@project.id}"
        }
      end
    else
      respond_to do |format|
        format.html {
          @title = "New feature"
          render "new"
        }
        format.json {
          render json: @feature.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    @feature = Feature.find(params[:id])
    add_crumb @feature.name, project_feature_path(@project,@feature)
    add_crumb "Edit"
    @title = "Edit feature"
  end

  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      respond_to do |format|
        format.html {
          flash[:success] = "Feature updated. #{undo_link}"
          redirect_to @project
        }
        format.json {
          render json: @feature, status: :created
        }
      end
    else
      respond_to do |format|
        format.html {
          @title = "Edit feature"
          render 'edit'
        }
        format.json {
          render json: @feature.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @feature = Feature.find(params[:id])
    @project = @feature.project
    @feature.destroy
    respond_to do |format|
      format.html { 
        flash[:succes] = "Feature destroyed."
        redirect_to @project 
      }
      format.json { head :no_content }
    end
  end

  def sort
    @project.features.each do |feature|
      feature.position = params["#{feature.id}"]
      feature.save
    end
    render :nothing => true
  end

  private

  def breadcrumb
    add_crumb @project.name.force_encoding(Encoding::UTF_8), project_path(@project)
  end
  
  def undo_link
    view_context.link_to("undo", revert_version_path(@feature.versions.scoped.last), :method => :post) if @feature.versions.any?
  end
end
