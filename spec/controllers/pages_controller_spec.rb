require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do

    before(:each) do
      get 'home'
      @project = Factory(:project)
      @projects = [@project]
      35.times do
        @projects << Factory(:project, :name => Factory.next(:name))
      end
    end

    it "should be successful" do
      response.should be_success
    end
    
    
    describe "for signed-in user" do
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        get 'home'
      end
      it "should have a link to create a new project" do
        response.should have_selector("a", :href => new_project_path)
      end

    end


  end

end