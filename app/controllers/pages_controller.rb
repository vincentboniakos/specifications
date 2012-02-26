# coding: utf-8
class PagesController < ApplicationController
  include PagesHelper
  add_crumb "Projects"
  
  def home
    @actions = home_actions
    @title = "Your projects"
    @projects = Project.joins(:stakeholders).where("user_id = ?",current_user.id).page(params[:page]).per(10) if signed_in?
  end

end
