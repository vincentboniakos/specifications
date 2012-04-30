# coding: utf-8
class PagesController < ApplicationController
  include PagesHelper
  add_crumb "Projects"
  
  def home
  	redirect_to projects_path if signed_in?
  end

end
