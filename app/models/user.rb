# coding: utf-8
class User < ActiveRecord::Base

  validates_presence_of :invitation_id, :message => 'is required'
  validates_uniqueness_of :invitation_id

  belongs_to :invitation


  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :invitation_token
  
  attr_accessor :password
  before_save :encrypt_password
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => email_regex
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_length_of :first_name, :maximum => 50
  validates_length_of :last_name, :maximum => 50
  
  
  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.password_salt == cookie_salt) ? user : nil
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def name 
    self.first_name + " " + self.last_name
  end
end