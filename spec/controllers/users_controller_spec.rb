require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("img", :class => "gravatar")
    end
  
  end
  
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
  end
  
  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :first_name => "", :last_name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should highlight the fields that are wrong" do
        post :create, :user => @attr
        response.should have_selector("div", :class => "clearfix error")
      end
      
      it "should display the reason of the error" do
        post :create, :user => @attr
        response.should have_selector("span", :class => "help-inline")
      end
      
    end
    
    describe "success" do

      before(:each) do
        @attr = { :first_name => "New", :last_name => "User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the root page" do
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end   
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to specifications/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
       
    end

  end
  
end