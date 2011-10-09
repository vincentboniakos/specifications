class UserstoriesController < ApplicationController
  before_filter :authenticate

  def update
    @userstory = Userstory.find(params[:id])
    if @userstory.update_attributes(params[:userstory])
      flash[:success] = "User story updated."
      redirect_to project_feature_path(@userstory.feature.project,@userstory.feature)
    else
      @title = "Edit feature"
      render 'edit'
    end
  end
  
  def destroy
    @userstory = Userstory.find(params[:id])
    @project = @userstory.feature.project
    @userstory.destroy
    flash[:succes] = "User story destroyed."
    redirect_to @project
  end
end
