module ProjectsHelper

	def get_project
		@project = Project.find(params[:project_id])
	end
  
end