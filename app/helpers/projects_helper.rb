module ProjectsHelper
  def project_show_title
    "#{@project.name} <small><a href='#{edit_project_path}'>edit</a></small>".html_safe
  end
  def add_feature_action
    "<a href='#{new_project_feature_path @project}' class ='btn success new-action'><strong>+</strong> New feature </a>".html_safe
  end
end
