# coding: utf-8
class UsersController < ApplicationController
  include UsersHelper
  before_filter :authenticate, :only => [:show, :index, :destroy]
  before_filter :breadcrumb
  before_filter :admin_user, :only => [:destroy]
  
  def show
    @user =  User.find(params[:id])
    add_crumb @user.name
    @title = @user.name
  end
  
  def new
    @title = "Sign up"
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
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

  def index
    @users = User.page(params[:page]).per(10)
    @title = "People"
    add_crumb "People"
    @actions = add_user_action
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:succes] = "User destroyed."
    redirect_to users_path
  end


  private
    def breadcrumb
      add_crumb "Home", root_path
    end

    def admin_user
      if  !current_user.admin?
        flash[:error] = "You are not authorized to do this"
        redirect_to(root_path)
      end 
    end
end
