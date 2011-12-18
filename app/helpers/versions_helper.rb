module VersionsHelper

	def label_for_activity item_type
		css_class = case item_type
			when "Userstory" then "success"
			when "Feature" then "notice"
		end
		
		"<span class='label #{css_class}'>#{item_type}</span>".html_safe
		 
	end

	def action_for_activity version
		action = case version.event
			when "update" then "Modified"
			when "create" then "Created"
			when "destroy" then "Deleted"
		end
		user = User.find(version.whodunnit)
		"#{action} by <a href='#{user_path user}'>#{user.first_name} #{user.last_name.first}.</a>".html_safe 
	end

	def content_for_activity version
		content = case version.item_type
			when "Userstory" then 
				userstory = Userstory.find(version.item_id)
				case version.event
					when "create" then 
						if (userstory.versions.length == 1) then
							content_for_userstory userstory
						else
							content_for_userstory userstory.versions[-userstory.versions.length+1].reify 
						end
					when "update" then 
						if (userstory.versions.last == version)
							diff(userstory, userstory.previous_version)
						else
							diff(version.next.reify, version.reify)
						end
				end		
			when "Feature" then 
				feature = Feature.find(version.item_id)
				case version.event
					when "create" then 
						if (feature.versions.length == 1) then
							content_for_feature feature
						else
							content_for_feature feature.versions[-feature.versions.length+1].reify
						end
					when "update" then 
						if (feature.versions.last == version)
							content_for_feature feature
						else
							content_for_feature feature.versions[-feature.versions.length+1].reify
						end
				end
		end
	end

	private

		def diff (next_userstory, previous_userstory)
			"<code>#{previous_userstory.content.force_encoding(Encoding::UTF_8)}</code><br/><code class='current'>#{next_userstory.content.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

		def content_for_feature feature
			"<code class='creation'><strong>#{feature.name.force_encoding(Encoding::UTF_8)}</strong><br/> #{feature.description.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

		def content_for_userstory userstory
			"<code class='creation'>#{userstory.content.force_encoding(Encoding::UTF_8)}</code>".html_safe
		end

end
