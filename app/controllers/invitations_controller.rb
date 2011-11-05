class InvitationsController < ApplicationController

	before_filter :breadcrumb, :except => [:index]
	before_filter :authenticate, :only => [:index]
	before_filter :admin_user, :only => [:index]

	def new
	  @invitation = Invitation.new
	  if signed_in? 
	  	@send_label = "Send an invitation"
	  else
	  	@send_label = "Ask for an invitation"
	  end
	  @title = "Invitation"
	end

	def create
	  @invitation = Invitation.new(params[:invitation])
	  if @invitation.save
	    if signed_in?
	      send_invitation
	    else
	      flash[:notice] = "Thank you, we will notify when we are ready."
	      redirect_to root_url
	    end
	  else
	    render :action => 'new'
	  end
	end

	def update
		@invitation = Invitation.find(params[:id])
		send_invitation if signed_in?
	end

	def index
		add_crumb "Home", root_path
		add_crumb "Pending invitations"
		@title = "Pending invitations"
		@invitations = Invitation.pendings.page(params[:page]).per(10)
	end

	private
		def breadcrumb
			add_crumb "Home", root_path
			add_crumb "Invitations", users_path
	  		add_crumb "New invitation"
		end

		def send_invitation
	    		Mailer.invitation(@invitation, signup_url(@invitation.token)).deliver
	    		flash[:notice] = "Thank you, the invitation was sent."
	    		redirect_to root_url
		end
	
end