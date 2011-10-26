class InvitationsController < ApplicationController

	before_filter :breadcrumb

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
	      Mailer.invitation(@invitation, signup_url(@invitation.token)).deliver
	      flash[:notice] = "Thank you, the invitation was sent."
	      redirect_to root_url
	    else
	      flash[:notice] = "Thank you, we will notify when we are ready."
	      redirect_to root_url
	    end
	  else
	    render :action => 'new'
	  end
	end

	private
		def breadcrumb
			add_crumb "Home", root_path
	  		add_crumb "New invitation"
		end
	
end