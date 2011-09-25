class Project < ActiveRecord::Base
  default_scope order('created_at DESC')
  validates_presence_of :name 
  validates_length_of :name, :maximum => 50
  validates_length_of :description, :maximum => 512
  validates_uniqueness_of :name
end
