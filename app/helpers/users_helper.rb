module UsersHelper
  def gravatar_for(user, options = { :size => 150 })
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

  def add_user_action
    "<a title='Invite people' href='#{new_invitation_path}' class ='btn success new-action'><strong>+</strong> Invite people </a>".html_safe
  end

end
