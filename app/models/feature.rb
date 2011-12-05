# coding: utf-8
class Feature < ActiveRecord::Base
  has_paper_trail :meta => { :project_id  => Proc.new { |feature| feature.project.id } }
  default_scope order('created_at DESC')
  validates_presence_of :name 
  validates_length_of :name, :maximum => 50
  validates_length_of :description, :maximum => 250
  validates_presence_of :project_id
  
  belongs_to :project
  has_many :userstories, :dependent => :destroy
end
