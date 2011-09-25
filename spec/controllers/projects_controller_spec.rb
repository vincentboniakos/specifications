require 'spec_helper'

describe ProjectsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "New project")
    end
  end

  describe "GET 'index'" do
    
    before(:each) do
      @project = Factory(:project)
      @projects = [@project]
      35.times do
        @projects << Factory(:project, :name => Factory.next(:name))
      end
    end
    
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Projects")
    end
    
    it "should have an element for each project" do
      get :index
      @projects[0..3].each do |project|
        response.should have_selector("a", :content => project.name, :href => project_path(assigns(project)))
      end
    end

    it "should paginate projects" do
      get :index
      response.should have_selector("nav.pagine")
      response.should have_selector("a", :href => "/projects?page=2",
      :content => "2")
      response.should have_selector("a", :href => "/projects?page=2",
      :content => "Next")
    end
    
  end


  describe "GET 'show'" do
    before(:each) do
      @project = Factory(:project)
    end

    it "should be successful" do
      get :show, :id => @project
      response.should be_success
    end

    it "should find the right project" do
      get :show, :id => @project
      assigns(:project).should == @project
    end
    
    it "should have the right title" do
      get :show, :id => @project
      response.should have_selector("title", :content => @project.name)
    end

    it "should include the project's name" do
      get :show, :id => @project
      response.should have_selector("h1", :content => @project.name)
    end

    it "should include the project's description" do
      get :show, :id => @project
      response.should have_selector("p", :content => @project.description)
    end
    
  end
  
  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :description => "Lorem ipsum"}
      end

      it "should not create a project" do
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end

      it "should have the right title" do
        post :create, :project => @attr
        response.should have_selector("title", :content => "New project")
      end

      it "should render the 'new' page" do
        post :create, :project => @attr
        response.should render_template('new')
      end
      
      it "should highlight the fields that are wrong" do
        post :create, :project => @attr
        response.should have_selector("div", :class => "clearfix error")
      end
      
      it "should display the reason of the error" do
        post :create, :project => @attr
        response.should have_selector("span", :class => "help-inline")
      end
      
    end
    
    describe "success" do

      before(:each) do
        @attr = { :name => "My project", :description => "Lorem ipsum"}
      end

      it "should create a project" do
        lambda do
          post :create, :project => @attr
        end.should change(Project, :count).by(1)
      end

      it "should redirect to the project page" do
        post :create, :project => @attr
        response.should redirect_to(project_path(assigns(:project)))
      end   
      
      it "should have a confirmation message" do
        post :create, :project => @attr
        flash[:success].should =~ /Your project has been created successfully./i
      end
       
    end

  end

end
