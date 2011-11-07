require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    before(:each) do
      @invitation = Factory(:invitation)
    end

    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path :invitation_token => @invitation.token
          fill_in "First Name",   :with => ""
          fill_in "Last Name",    :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Password Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("span.help-inline")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path :invitation_token => @invitation.token
          fill_in "First Name",   :with => "Example"
          fill_in "Last Name",    :with => "User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Password Confirmation", :with => "foobar"
          click_button
          response.should  have_selector("div.success",
                                        :content => "Welcome")
          response.should render_template('pages/home')
        end.should change(User, :count).by(1)
      end
    end

  end
  
  
  
  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit login_path
        fill_in :email,    :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in user
        controller.should be_signed_in
        click_link "Log out"
        controller.should_not be_signed_in
      end
    end
  end
  
  
end
