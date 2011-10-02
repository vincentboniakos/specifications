module PagesHelper
  def home_actions
    "<a href='#{new_project_path}' class ='btn success new-action'><strong>+</strong> New project </a>".html_safe
  end

end
