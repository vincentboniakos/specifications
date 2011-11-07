require "spec_helper"

describe Mailer do
  describe "invitation" do

    before(:each) do
      @invitation = Factory(:invitation)
      @mail = Mailer.invitation(@invitation,signup_url(@invitation.token))
    end

    it "renders the headers" do
      @mail.subject.should eq("Invitation")
      @mail.to.should eq([@invitation.recipient_email])
      @mail.from.should eq(["vincent.b@5emegauche.com"])
    end

    it "renders the sigup url" do
      @mail.body.encoded.should match(signup_url(:invitation_token => @invitation.token))
    end
  end

end
