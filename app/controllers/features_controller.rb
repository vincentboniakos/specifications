# coding: utf-8
class FeaturesController < ApplicationController
  include FeaturesHelper
  add_crumb "Projects", :root_path
  before_filter :authenticate
  before_filter :get_project
  before_filter :is_stakeholder

  
  def index
    @features = @project.features
    respond_to do |format|
      format.json { render json: @features }
    end
  end
    

  def show
    @feature = Feature.find(params[:id])
    respond_to do |format|
      format.json {render json: @feature}
    end
  end

  def create
    @feature = @project.features.build(params[:feature])
    @feature.position = 0
    if @feature.save
      respond_to do |format|
        format.json {
          render json: @feature, status: :created, location: "##{@project.id}"
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

  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      respond_to do |format|
        format.json {
          render json: @feature, status: :created
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
    @feature = Feature.find(params[:id])
    @feature.destroy
    respond_to do |format|
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

end
