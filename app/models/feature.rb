class Feature < ActiveRecord::Base
  default_scope order('created_at DESC')
  validates_presence_of :name 
  validates_length_of :name, :maximum => 50
  validates_length_of :description, :maximum => 140
  validates_presence_of :project_id
  
  belongs_to :project
end
