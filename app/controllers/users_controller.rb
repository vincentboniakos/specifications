# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]
  
  def show
    @user =  User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Specifications"
      redirect_to root_url
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render "new"
    end
  end

end
