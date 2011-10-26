require 'spec_helper'

describe "Invitations" do


  describe "failure" do 
    it "should not create an invitation" do
      lambda do
          visit invitation_path
          fill_in :invitation_recipient_email, :with => ""
          click_button
          response.should render_template('invitations/new')
          response.should have_selector("span.help-inline")
      end.should_not change(Invitation, :count)
    end
  end

  describe "success" do 
    it "should create an invitation" do
      lambda do
          visit invitation_path
          fill_in :invitation_recipient_email, :with => "yann.gallet@example.com"
          click_button
          response.should render_template('invitations/new')
      end.should change(Invitation, :count).by(1)
    end
  end
end
