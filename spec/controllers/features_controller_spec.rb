require 'spec_helper'

describe FeaturesController do
  render_views

  before(:each) do
    @project = Factory(:project)
  end

  describe "GET 'new'" do
    describe "for non signed-in user" do
      it "should deny access" do
        get :new, :project_id => @project
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      it "should be successful" do

        get :new, :project_id => @project
        response.should be_success
      end

      it "should have the right title" do

        get :new, :project_id => @project
        response.should have_selector("title", :content => "New feature")
      end
    end
  end


  describe "GET 'show'" do
    before(:each) do
      @feature = Factory(:feature)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        get :show, :id => @feature, :project_id => @project
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do

      before(:each) do
        test_sign_in(Factory(:user))
      end

      def get_show       
        get :show, :id => @feature, :project_id => @project
      end

      it "should be successful" do
        get_show
        response.should be_success
      end

      it "should find the right feature" do
        get_show
        assigns(:feature).should == @feature
      end

      it "should have the right title" do
        get_show
        response.should have_selector("title", :content => @feature.name)
      end

      it "should include the project's name" do
        get_show
        response.should have_selector("h1", :content => @feature.name)
      end

      it "should include the project's description" do
        get_show
        response.should have_selector("p", :content => @feature.description)
      end

      it "should have a link to edit the feature" do
        get_show
        response.should have_selector("a", :href => edit_project_feature_path(@feature.project,@feature))
      end
    end
  end

  describe "POST 'create'" do

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :name => "My feature", :description => "Lorem ipsum"}
        post :create, :feature => @attr, :project_id => @project
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

        it "should not create a feature" do

          lambda do
            post :create, :feature => @attr, :project_id => @project
          end.should_not change(Project, :count)
        end

        it "should have the right title" do

          post :create, :feature => @attr, :project_id => @project
          response.should have_selector("title", :content => "New feature")
        end

        it "should render the 'new' page" do      
          post :create, :feature => @attr, :project_id => @project
          response.should render_template('new')
        end

        it "should highlight the fields that are wrong" do

          post :create, :feature => @attr, :project_id => @project
          response.should have_selector("div", :class => "clearfix error")
        end

        it "should display the reason of the error" do        
          post :create, :feature => @attr, :project_id => @project
          response.should have_selector("span", :class => "help-inline")
        end

      end

      describe "success" do

        before(:each) do
          @attr = { :name => "My feature", :description => "Lorem ipsum"}
        end

        it "should create a feature" do

          lambda do
            post :create, :feature => @attr, :project_id => @project
          end.should change(Feature, :count).by(1)
        end

        it "should redirect to the project page" do

          post :create, :feature => @attr, :project_id => @project
          response.should redirect_to(project_path(@project))
        end   

        it "should have a confirmation message" do

          post :create, :feature => @attr, :project_id => @project
          flash[:success].should =~ /Your feature has been created successfully./i
        end

      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @feature = Factory(:feature)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        get :edit, :id => @feature, :project_id => @project
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      it "should be successful" do

        get :edit, :id => @feature, :project_id => @project
        response.should be_success
      end

      it "should find the right feature" do

        get :edit, :id => @feature, :project_id => @project
        assigns(:feature).should == @feature
      end

      it "should have the right title" do

        get :edit, :id => @feature, :project_id => @project
        response.should have_selector("title", :content => "Edit feature")
      end

      it "should have a cancel button that redirect to show feature" do

        get :edit, :id => @feature, :project_id => @project
        response.should have_selector("a", :href => project_feature_path(@project,@feature))
      end
    end
  end

  #########################
  #### PUT UPDATE
  #########################

  describe "PUT 'update'" do

    before(:each) do
      @feature = Factory(:feature)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :name => "New Name", :description => "blabla"}
        put :update, :id => @feature, :feature => @attr, :project_id => @project
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

          put :update, :id => @feature, :feature => @attr, :project_id => @project
          response.should render_template('edit')
        end

        it "should have the right title" do

          put :update, :id => @feature, :feature => @attr, :project_id => @project
          response.should have_selector("title", :content => "Edit feature")
        end
      end

      describe "success" do

        before(:each) do
          @attr = { :name => "New Name", :description => "blabla"}
        end

        it "should change the feature's attributes" do

          put :update, :id => @feature, :feature => @attr, :project_id => @project
          @feature.reload
          @feature.name.should  == @attr[:name]
          @feature.description.should == @attr[:description]
        end

        it "should redirect to the feature show page" do

          put :update, :id => @feature, :feature => @attr, :project_id => @project
          response.should redirect_to(project_feature_path(@project,@feature))
        end

        it "should have a flash message" do

          put :update, :id => @feature, :feature => @attr, :project_id => @project
          flash[:success].should =~ /updated/
        end
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for a non signed in user" do

      before(:each) do
        @feature = Factory(:feature)
      end

      it "should deny access" do
        delete :destroy, :id => @feature, :project_id => @project
        response.should redirect_to(login_path)
      end
    end

    describe "for a signed in user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @feature = Factory(:feature)
      end

      it "should destroy the project" do
        lambda do 
          delete :destroy, :id => @feature, :project_id => @project
        end.should change(Feature, :count).by(-1)
      end
    end
  end

  ######################################
  ## POST USERSTORIES
  ######################################

  describe "POST 'userstories'" do

    before (:each) do 
      @feature = Factory(:feature)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :content => "My userstory"}
        post :userstories, :userstory => @attr, :id => @feature, :project_id => @feature.project 
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      def post_userstories
        post :userstories, :userstory => @attr, :id => @feature, :project_id => @feature.project 
      end


      describe "failure" do

        before(:each) do
          @attr = { :content => ""}
        end

        it "should not create a feature" do

          lambda do
            post_userstories
          end.should_not change(Project, :count)
        end

        it "should display an error message" do 
          post_userstories
          response.should have_selector("span", :class => "help-inline")
        end

      end

      describe "success" do

        before(:each) do
          @attr = { :content => "My User story" }
        end

        it "should create a userstories" do          
          lambda do
            post_userstories
          end.should change(Userstory, :count).by(1)
        end
        it "should create a user story using Ajax" do
          lambda do
            xhr :post, :userstories, :userstory => @attr, :id => @feature, :project_id => @feature.project
            response.should be_success
          end.should change(Userstory, :count).by(1)
        end
      end
    end
  end

end
