module FeaturesHelper
  def feature_show_title
    "#{@feature.name.force_encoding(Encoding::UTF_8)} <small><a href='#{edit_project_feature_path @feature.project}'>edit</a></small><small class='danger'><a href='#{project_feature_path @feature.project, @feature }' data-confirm='Are you sure?' data-method='delete' rel='nofollow' title='Delete #{@feature.name.force_encoding(Encoding::UTF_8)}'>Delete this feature</a></small>".html_safe
  end
end
