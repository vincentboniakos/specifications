module PagesHelper
  def home_actions
    "<a href='#{new_project_path}' class ='btn success new-action'><i class='icon-book icon-white'></i>&nbsp;&nbsp;New project </a>".html_safe
  end

end
