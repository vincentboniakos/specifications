require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    
    before(:each) do
      get :home
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should have the right title" do
      response.should have_selector("title", :content => "#{@base_title} | Home")
    end
    
  end
end