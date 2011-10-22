require 'spec_helper'

describe "Invitations" do

  
  describe "list" do
    before(:each) do
      visit root_path
    end
    describe "when not siged-in" do
      it "should display a welcome message" do
        response.should have_selector("section.hero-unit")
      end
    end
    describe "when siged-in" do
      before(:each) do
        @user = Factory(:user)
        integration_sign_in @user
      end
      it "should display the projects" do
        response.should have_selector("a", :href => new_project_path)
      end
    end
  end

  describe "creation" do
    
    before(:each) do
      @user = Factory(:user)
      integration_sign_in @user
    end
    
    describe "failure" do
    
      it "should not make a new project" do
        lambda do
          visit new_project_path
          fill_in :project_name, :with => ""
          fill_in :project_description, :with => ""
          click_button
          response.should render_template('projects/new')
          response.should have_selector("span.help-inline")
        end.should_not change(Project, :count)
      end
    end

    describe "success" do
  
      it "should make a new project" do
        name = "Project name"
        description = "Lorem ipsum dolr sit amet"
        lambda do
          visit new_project_path
          fill_in :project_name, :with => name
          fill_in :project_description, :with => description
          click_button
          response.should have_selector("h1", :content => name)
          response.should have_selector("p", :content => description)
        end.should change(Project, :count).by(1)
      end
    end
  end
end
