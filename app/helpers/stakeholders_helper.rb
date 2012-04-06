module StakeholdersHelper

	def is_stakeholder
	  if signed_in?
	    if !@project.users.find_by_id(current_user.id)
	      if request.xhr?
	      	head(:forbidden)
	      else
	      	flash[:error] = "You are not authorized to access this resource."
	      	redirect_to root_path, :error => "You are not authorized to access to this resource."
	  	  end
	    end
	  end
	end
end
