require 'spec_helper'

describe ProjectsController do
  render_views

  describe "GET 'new'" do
    describe "for non signed-in user" do
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      it "should be successful" do
        
        get :new
        response.should be_success
      end

      it "should have the right title" do
        
        get :new
        response.should have_selector("title", :content => "New project")
      end
    end
  end


  describe "GET 'show'" do
    before(:each) do
      @project = Factory(:project)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        get :show, :id => @project
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      
      before(:each) do
        test_sign_in(Factory(:user))
        @feature = @project.features.create!(:name => "first")
        @second = @project.features.create!(:name => "second")
        @third = @project.features.create!(:name => "third")
        @features = [@feature,@second,@third]
      end
      
      def get_show       
        get :show, :id => @project
      end
      
      it "should be successful" do
        get_show
        response.should be_success
      end

      it "should find the right project" do
        get_show
        assigns(:project).should == @project
      end

      it "should have the right title" do
        get_show
        response.should have_selector("title", :content => @project.name)
      end

      it "should include the project's name" do
        get_show
        response.should have_selector("h1", :content => @project.name)
      end

      it "should include the project's description" do
        get_show
        response.should have_selector("p", :content => @project.description)
      end

      it "should have a link to edit the project" do
        get_show
        response.should have_selector("a", :href => edit_project_path(assigns[@project]))
      end
      it "should display the features of the project" do
        get_show
        @features[0..2].each do |feature|
          response.should contain(feature.name)
        end
      end
      it "should not display the features of other projects" do
        @other_project = Factory( :project )
        @other_feature = @other_project.features.create!( :name=> "other feature" )
        get_show
        response.should_not contain(@other_feature.name)
      end
    end
  end

  describe "POST 'create'" do

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :name => "My project", :description => "Lorem ipsum"}
        post :create, :project => @attr
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      

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
          
          post :create, :project => @attrpost_create
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

  describe "GET 'edit'" do
    before(:each) do
      @project = Factory(:project)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        get :edit, :id => @project
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      it "should be successful" do
        
        get :edit, :id => @project
        response.should be_success
      end

      it "should find the right project" do
        
        get :edit, :id => @project
        assigns(:project).should == @project
      end

      it "should have the right title" do
        
        get :edit, :id => @project
        response.should have_selector("title", :content => "Edit project")
      end

      it "should have a cancel button that redirect to show project" do
        
        get :edit, :id => @project
        response.should have_selector("a", :href => project_path(@project))
      end
    end
  end

  #########################
  #### PUT UPDATE
  #########################

  describe "PUT 'update'" do

    before(:each) do
      @project = Factory(:project)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :name => "New Name", :description => "blabla"}
        put :update, :id => @project, :project => @attr
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      describe "failure" do

        before(:each) do
          @attr = { :name => "", :description => "blabla" }
        end

        it "should render the 'edit' page" do
          
          put :update, :id => @project, :project => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          
          put :update, :id => @project, :project => @attr
          response.should have_selector("title", :content => "Edit project")
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :name => "New Name", :description => "blabla"}
        end

        it "should change the project's attributes" do
          
          put :update, :id => @project, :project => @attr
          @project.reload
          @project.name.should  == @attr[:name]
          @project.description.should == @attr[:description]
        end

        it "should redirect to the project show page" do
          
          put :update, :id => @project, :project => @attr
          response.should redirect_to(project_path(@project))
        end

        it "should have a flash message" do
          
          put :update, :id => @project, :project => @attr
          flash[:success].should =~ /updated/
        end
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    describe "for a non signed in user" do

      before(:each) do
        @project = Factory(:project)
      end

      it "should deny access" do
        delete :destroy, :id => @project
        response.should redirect_to(login_path)
      end
    end

    describe "for a signed in user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @project = Factory(:project)
      end

      it "should destroy the project" do
        lambda do 
          delete :destroy, :id => @project
        end.should change(Project, :count).by(-1)
      end
    end
  end
  
  ####################################
  ## GET ACTIVITY
  ####################################
  
  describe "GET 'activity'" do
    before(:each) do
      @project = Factory(:project)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        get :activity, :project_id => @project
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      
      before(:each) do
        test_sign_in(Factory(:user))
        @feature = @project.features.create!(:name => "first")
        @second = @project.features.create!(:name => "second")
        @third = @project.features.create!(:name => "third")
        @features = [@feature,@second,@third]
      end
      
      def get_activity       
        get :activity, :project_id => @project
      end
      
      it "should be successful" do
        get_activity
        response.should be_success
      end

      it "should find the right project" do
        get_activity
        assigns(:project).should == @project
      end

      it "should have the right title" do
        get_activity
        response.should have_selector("title", :content => @project.name)
      end

      it "should include the project's name" do
        get_activity
        response.should have_selector("h1", :content => @project.name)
      end

      it "should include the project's description" do
        get_activity
        response.should have_selector("p", :content => @project.description)
      end

      it "should have a link to edit the project" do
        get_activity
        response.should have_selector("a", :href => edit_project_path(assigns[@project]))
      end
      
    end
  end
  
end
