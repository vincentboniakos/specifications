require 'spec_helper'

describe Invitation do
  before(:each) do
    @attr = {
      :recipient_email => "thierry@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@attr)
  end

  it "should require a recipient email" do
    no_ename_invitation = Invitation.new(@attr.merge(:recipient_email => ""))
    no_ename_invitation.should_not be_valid
  end

  it "should reject recipient that is already registered" do
  	@user = Factory(:user)
    already_exist_recipient = Invitation.new(@attr.merge(:recipient_email => @user.email))
    already_exist_recipient.should_not be_valid
  end

  it "should generate a token" do
    @invitation = Invitation.create!(@attr)
    @invitation.token.should_not be_nil
  end

  it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = Invitation.new(@attr.merge(:recipient_email => address))
        valid_email_user.should be_valid
      end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = Invitation.new(@attr.merge(:recipient_email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should have a pending method that returns only the invitation that has not been sent" do
    @invitation_sent = Invitation.create!({:recipient_email => "invitations_sent@exemple.com", :sent_at => Time.now})
    @invitation_not_sent = Invitation.create!({:recipient_email => "invitations_not_sent@exemple.com"})

    Invitation.should respond_to(:pendings)

    Invitation.pendings.length.should == 1
  end

end
