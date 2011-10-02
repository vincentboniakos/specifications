module FeaturesHelper
  def feature_show_title
    "#{@feature.name} <small><a href='#{edit_project_feature_path @feature.project}'>edit</a></small>".html_safe
  end
end
