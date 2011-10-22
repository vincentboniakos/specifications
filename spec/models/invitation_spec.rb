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

end
