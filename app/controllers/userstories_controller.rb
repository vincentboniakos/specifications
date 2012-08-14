# coding: utf-8
class UserstoriesController < ApplicationController
  before_filter :authenticate
  before_filter :get_project
  before_filter :is_stakeholder

  #respond_to :html, :xml, :json
  add_crumb "Projects", :root_path
  before_filter :breadcrumb, :only => [:show]

  def index
    @feature = Feature.find(params[:feature_id])
    respond_to do |format|
      format.json { render json: @feature.userstories }
    end
  end

  def show
    @userstory = Userstory.find(params[:id])
    add_crumb @userstory.feature.name.force_encoding(Encoding::UTF_8), project_feature_path(@project, @userstory.feature)
    add_crumb "Userstory #{@userstory.id}"
    @title = @userstory.content
    @comment = Comment.new
    @comments = @userstory.comments
  end

  def update
    @userstory = Userstory.find(params[:id])
    if @userstory.update_attributes(params[:userstory])
      respond_to do |format|
        format.json {
          render json: @userstory, status: :created
        }
      end
    else
      respond_to do |format|
        format.json {
          render json: @feature.errors, status: :unprocessable_entity
        }
      end
    end
  end


  def destroy
    @userstory = Userstory.find(params[:id])
    if request.xhr?
      if @userstory.destroy
        render :nothing => true, :status => :accepted     
      else
        render :nothing => true, :status => :forbidden
      end
    end
  end

  def create
    @feature = Feature.find(params[:feature_id])
    @userstories = @feature.userstories
    @userstory = @feature.userstories.build(params[:userstory])
    if @userstory.save
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => "userstories/userstory", :locals => { :userstory => @userstory }, :layout => false, :status => :created
          end
        end
      end
    else
      respond_to do |format|
        format.html do
          if request.xhr?
            render :json => @userstory.errors, :status => :unprocessable_entity
          end
        end
      end
    end
  end

  def sort
    userstories = @project.userstories
    @project.features.each do |feature|
      if !params["#{feature.id}"].nil?
        params["#{feature.id}"].each do |param_userstory|
          if param_userstory[1] != "undefined"
            userstory = userstories.find(param_userstory[1])
            userstory.feature_id = feature.id
            userstory.position = param_userstory[0].to_i + 1
            userstory.save
          end
        end
      end
    end
    render :nothing => true
  end

  private
    def breadcrumb
      add_crumb @project.name.force_encoding(Encoding::UTF_8), project_path(@project)
    end
end
