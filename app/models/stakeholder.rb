class Stakeholder < ActiveRecord::Base
	belongs_to :user
	belongs_to :project

	validates_presence_of :project_id
	validates_presence_of :user_id

	validates_uniqueness_of :project_id, :scope =>[:user_id]
end
