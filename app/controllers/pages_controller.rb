class PagesController < ApplicationController
  include PagesHelper
  def home
    @actions = home_actions
    @title = "Your projects"
    @projects = Project.page(params[:page]).per(10)
  end

end
