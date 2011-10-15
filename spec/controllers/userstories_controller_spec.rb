require 'spec_helper'

describe UserstoriesController do
  render_views
  
  before(:each) do
    @project = Factory(:project)
  end
  

  #########################
  #### PUT UPDATE
  #########################

  describe "PUT 'update'" do

    before(:each) do
      @userstory = Factory(:userstory)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :content => "New content"}
        put :update, :id => @userstory, :userstory => @attr
        response.should redirect_to(login_path)
      end
    end
    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      def put_update_ajax
        xhr :put, :update, :id => @userstory, :userstory => @attr
      end
      
      describe "failure" do

        before(:each) do
          @attr = { :content => ""}
        end

        it "should display an error message"
      
      end

      describe "success" do

        before(:each) do
          @attr = { :content => "New Content"}
        end

        it "should change the userstory's attributes using ajax" do
          put_update_ajax
          @userstory.reload
          @userstory.content.should  == @attr[:content]
        end

      end
    end
  end
  
  ######################
  ## DELETE DESTROY
  ######################
  
  describe "DELETE 'destroy'" do

    describe "for a non signed in user" do

      before(:each) do
         @userstory = Factory(:userstory)
      end

      it "should deny access" do
        delete :destroy, :id => @userstory
        response.should redirect_to(login_path)
      end
    end

    describe "for a signed in user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @userstory = Factory(:userstory)
      end
      
      def delete_destroy_ajax
        xhr :delete, :destroy, :id => @userstory
      end

      it "should destroy the userstory using ajax" do
        lambda do 
          delete_destroy_ajax
        end.should change(Userstory, :count).by(-1)
      end
    end
  end
  
  #########################
  ## POST CREATE
  #########################
  describe "POST 'create'" do

    before (:each) do 
      @feature = Factory(:feature)
    end

    describe "for non signed-in user" do
      it "should deny access" do
        @attr = { :content => "My userstory"}
        post :create, :userstory => @attr, :feature_id => @feature, :project_id => @feature.project 
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      def post_create_ajax
        xhr :post, :create, :userstory => @attr, :feature_id => @feature, :project_id => @feature.project
      end


      describe "failure" do

        before(:each) do
          @attr = { :content => ""}
        end

        it "should not create a user story using ajax" do
          lambda do
            post_create_ajax
          end.should_not change(Userstory, :count)
        end

      end

      describe "success" do

        before(:each) do
          @attr = { :content => "My User story" }
        end

        it "should create a user story using Ajax" do
          lambda do
            post_create_ajax
            response.should be_success
          end.should change(Userstory, :count).by(1)
        end
      end
    end
  end
  
end
