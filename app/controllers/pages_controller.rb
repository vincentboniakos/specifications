class PagesController < ApplicationController
  
  def home
    @title = "Home"
    @projects = Project.page(params[:page]).per(10)
  end

end
