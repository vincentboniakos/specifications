class Project < ActiveRecord::Base
  validates_presence_of :name 
  validates_length_of :name, :maximum => 50
  validates_uniqueness_of :name
end
