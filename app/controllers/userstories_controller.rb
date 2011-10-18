# coding: utf-8
class UserstoriesController < ApplicationController
  before_filter :authenticate

  #respond_to :html, :xml, :json


  def update
    @userstory = Userstory.find(params[:id])
    if @userstory.update_attributes(params[:userstory])
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => "userstories/userstory", :locals => { :userstory => @userstory }, :layout => false, :status => :accepted
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


  def destroy
    @userstory = Userstory.find(params[:id])
    @project = @userstory.feature.project
    @userstory.destroy
    flash[:succes] = "User story destroyed."
    redirect_to @project
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
end
