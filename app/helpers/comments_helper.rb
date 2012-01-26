module CommentsHelper
	def time_format date
		date.strftime('%a, %d %b. %Y at %I:%M %p').downcase
	end

	def from_current_user? comment
		comment.user_id == current_user.id
	end

end
