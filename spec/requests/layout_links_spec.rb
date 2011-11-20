require 'spec_helper'

describe "LayoutLinks" do


  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => login_path,
                                         :content => "Log in")
    end

    it "should have a link to get an invitation" do
      visit root_path
      response.should have_selector("a", :href => new_invitation_path, :content => "Get an invitation")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      integration_sign_in @user
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => logout_path,
                                         :content => "Log out")
    end

    it "should have a link to see all the people registered" do
      visit root_path
      response.should have_selector("a", :href => users_path, :content => "People")
    end
    
    describe "and admin" do
      before(:each) do
        @user.toggle!(:admin)
      end
      it "should have a link to see the pending invitations" do
        visit root_path
        response.should have_selector("a", :href => invitations_path, :content => "Pending invitation")
      end
    end
    
  end
  
end
