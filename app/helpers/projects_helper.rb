module ProjectsHelper
  def project_show_title
    "#{@project.name.force_encoding(Encoding::UTF_8)} <small><a href='#{edit_project_path}'>edit</a></small><small class='danger'><a href='#{project_path @project}' data-confirm='Are you sure?' data-method='delete' rel='nofollow' title='Delete #{@project.name.force_encoding(Encoding::UTF_8)}'>Delete this project</a></small>".html_safe
  end
  def add_feature_action
    "<a title='Create a project' href='#{new_project_feature_path @project}' class ='btn success new-action'><strong>+</strong> New feature </a>".html_safe
  end

  def nav_features
  	nav = "<nav>"
  	nav += "<ul>"
  	@project.features.each do |feature|
  		nav += "<li><a href='#a_feature_#{feature.id}'>#{feature.name}</a></li>"
  	end
  	nav += "</ul>"
  	nav += "</nav>" 
  	return nav.html_safe
  end
end