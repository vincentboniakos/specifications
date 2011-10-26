# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]
  before_filter :breadcrumb
  
  def show
    @user =  User.find(params[:id])
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

  private
    def breadcrumb
      add_crumb "Home", root_path
        add_crumb "New invitation"
    end

end
