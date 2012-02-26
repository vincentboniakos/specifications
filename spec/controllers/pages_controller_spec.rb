require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do

    before(:each) do
      get 'home'
      @project = Factory(:project)
      
    end

    it "should be successful" do
      response.should be_success
    end
    
    
    describe "for signed-in user" do
      before (:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      it "should have a link to create a new project" do
        get 'home'
        response.should have_selector("a", :href => new_project_path)
      end

      it "should display the projects the current user is a stakeholder" do 
        @project.stakeholders.create!(:user_id => controller.current_user.id)
        @other_project = Factory(:project)
        get 'home'
        response.should have_selector("a", :href => project_path(@project))
        response.should_not have_selector("a", :href => project_path(@other_project))
      end

    end


  end

end