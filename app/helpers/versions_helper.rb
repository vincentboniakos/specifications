module VersionsHelper

	def date_format date 
		date.strftime('%A, %d %B %Y')
	end

	def label_for_activity version
		css_class = case version.event
			when "update" then "notice"
			when "create" then "success"
			when "destroy" then "important"
		end

		action = case version.event
			when "update" then "Modified"
			when "create" then "Created"
			when "destroy" then "Deleted"
		end
		
		"<span class='label #{css_class}'>#{action}</span>".html_safe
		 
	end

	def action_for_activity version
		user = User.find(version.whodunnit)
		"by <a href='#{user_path user}'>#{user.first_name} #{user.last_name.first}.</a>".html_safe 
	end

	def content_for_activity version
		content = case version.item_type
			when "Userstory" then 
				userstory = Userstory.find_by_id(version.item_id)
				case version.event
					when "create" then
						if userstory
							if (userstory.versions.length == 1) then
								content_for_userstory userstory
							else
								content_for_userstory userstory.versions[-userstory.versions.length+1].reify 
							end
						else
							content_for_userstory version.next.reify
						end
					when "update" then
						if userstory
							diff(userstory.previous_version, userstory)
						else
							diff(version.reify, version.next.reify)
						end
					when "destroy" then
						content_for_userstory(version.reify, true)
				end		
			when "Feature" then
				feature = Feature.find_by_id(version.item_id) 
				case version.event
					when "create" then				
						if feature
							content_for_feature feature
					    else
					    	content_for_feature version.next.reify
					    end
					when "update" then
						if feature
							content_for_feature feature
						else
							content_for_feature version.next.reify
						end
						
					when "destroy" then
						content_for_feature(version.reify, true)
				end
		end
	end

	private

		def diff (previous_userstory, next_userstory)
			"<code class='delete'>#{previous_userstory.content.force_encoding(Encoding::UTF_8)}</code><br/><code>#{next_userstory.content.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

		def content_for_feature (feature, delete = false)
			"<code#{" class='delete'" if delete}'><strong>#{feature.name.force_encoding(Encoding::UTF_8)}</strong><br/> #{feature.description.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

		def content_for_userstory (userstory, delete = false)
			"<code#{" class='delete'" if delete}>#{userstory.content.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

end
