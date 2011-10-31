require 'spec_helper'

describe UsersController do
  render_views

  ##########################
  ## GET SHOW
  ##########################

  describe "GET 'show'" do

    describe "for non signed-in user" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should deny access" do
        get :show, :id => @user
        response.should redirect_to(login_path)
      end

    end

    describe "for signed-in user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
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
  end



  ##########################
  ## GET NEW
  ##########################

  describe "GET 'new'" do

    before (:each) do
      @invitation = Factory(:invitation)
    end

    def get_new
      get :new, :invitation_token => @invitation.token
    end

    it "should be successful" do
      get_new
      response.should be_success
    end

    it "should have the right title" do
      get_new
      response.should have_selector("title", :content => "Sign up")
    end
  end


  ##########################
  ## POST CREATE
  ##########################

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @invitation = Factory(:invitation)
        @attr = { :first_name => "", :last_name => "", :email => "", :password => "",
          :password_confirmation => "", :invitation_token => @invitation.token}
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

        describe "when not invited" do
          before(:each) do
            @attr = { :first_name => "", :last_name => "", :email => "", :password => "",
          :password_confirmation => "", :invitation_token => "123"}
          end

          it "should tell the user he is not invited"
        end

      end

      describe "success" do

        before(:each) do
          @invitation = Factory(:invitation)
          @attr = { :first_name => "New", :last_name => "User", :email => "user@example.com",
            :password => "foobar", :password_confirmation => "foobar", :invitation_token => @invitation.token }
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


  ##########################
  ## GET INDEX
  ##########################

  describe "GET 'index'" do

    describe "when not signed in" do
      it "should deny access and redirect to the login path" do
        get :index
        response.should redirect_to(login_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      before(:each) do
        @users = [@user]
        35.times do
          @users << Factory(:user, :email => Factory.next(:email), :invitation => Factory(:invitation, :recipient_email =>  Factory.next(:email)))
        end
      end

      it "should be succesful" do 
        get :index
        response.should be_success
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..3].each do |user|
          response.should have_selector("a", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("nav.pagine")
        response.should have_selector("span.current", :content => "1")
        response.should have_selector("a", :href => "/users?page=2",
        :content => "2")
      end

      describe "and admin" do

        before(:each) do
          @user.toggle!(:admin)
        end

        it "should display a delete link for each user" do
          get :index
          @users[0..3].each do |user|
            response.should have_selector("a", :href => destroy_user_path(user))
          end
        end

      end

    end
  end

  ##########################
  ## DELETE DESTROY
  ##########################

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    def delete_destroy
      delete :destroy, :id => @user
    end

    describe "when not signed in" do
      it "should deny access" do
        delete_destroy
        response.should redirect_to(login_path)
      end
    end

    describe "when signed id" do
      
      before(:each) do 
        test_sign_in(@user)
      end

      describe "but not admin" do
        it "should deny access" do
          delete_destroy
          response.should redirect_to(root_path)
        end
        it "should not destroy the user" do
          lambda do
            delete_destroy
          end.should_not change(User, :count)
        end
      end
      describe "and admin" do
        before(:each) do 
          @user.toggle!(:admin)
        end
        it "should delete the user" do
          lambda do
            delete_destroy
          end.should change(User, :count).by(-1)
        end
        it "should redirect to users path" do
          delete_destroy
          response.should redirect_to(users_path)
        end
      end
    end
  end

end
