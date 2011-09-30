require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign up")
  end

  describe "when not signed in" do
    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => login_path,
                                         :content => "Log in")
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
    
  end
  
end
