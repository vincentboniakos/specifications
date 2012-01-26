class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :userstory
	validates_presence_of :userstory_id
	validates_presence_of :body

end
