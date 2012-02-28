class StakeholdersController < ApplicationController

  before_filter :authenticate
  before_filter :get_stakeholder, :only => [:destroy]
  before_filter :get_project

  def index
    add_crumb "Projects", root_path
  	add_crumb @project.name.force_encoding(Encoding::UTF_8), project_path(@project)
  	add_crumb "Stakeholders"
  	@users = User.all
    @stakeholder = @project.stakeholders.build()
  end

  def create
  	@stakeholder = @project.stakeholders.build(params[:stakeholder])
  	if @stakeholder.save
  		if request.xhr?
        render :partial => "stakeholders/destroy_stakeholder", :locals => { :project => @project, :stakeholder =>  @stakeholder}, :layout => false, :status => :ok
      end
  	else
  		head(:bad_request)
  	end
  end

  def destroy
    	@stakeholder.destroy
    	head(:ok)
  end

  private

  	def get_stakeholder
  		@stakeholder = Stakeholder.find_by_id(params[:id])
  		if @stakeholder
  			if @stakeholder.user_id == current_user.id
  				head(:foribidden)
  			end
  		else
			 head(:bad_request)
  		end
  	end

  	def get_project
      @project = Project.find(params[:project_id])
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
