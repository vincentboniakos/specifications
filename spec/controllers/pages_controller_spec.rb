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

    it "should have the right title" do
      response.should have_selector("title", :content => "#{@base_title} | Home")
    end

    it "should have a link to create a new project" do
      response.should have_selector("a", :href => new_project_path)
    end

    it "should have an element for each project" 

    it "should paginate projects"
    
    

  end

end