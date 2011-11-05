class Invitation < ActiveRecord::Base

	default_scope order('created_at DESC')
	has_one :recipient, :class_name => 'User'

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates_presence_of :recipient_email
	validate :recipient_is_not_registered
	validates_format_of :recipient_email, :with => email_regex

	before_create :generate_token

	private

	def recipient_is_not_registered
	  errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
	end

	def generate_token
	  self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end

	def self.pendings
		where(:sent_at => nil)
	end

end
