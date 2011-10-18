# coding: utf-8
class Userstory < ActiveRecord::Base
  default_scope order('created_at ASC')
  validates_presence_of :content 
  validates_length_of :content, :maximum => 250
  validates_presence_of :feature_id
  
  belongs_to :feature
end
