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
      describe "failure" do

        before(:each) do
          @attr = { :content => ""}
        end
        
        def put_update_fail
          put :update, :id => @userstory, :userstory => @attr
        end

        it "should display an error message"
      
      end

      describe "success" do

        before(:each) do
          @attr = { :content => "New Content"}
        end
        
        def put_update_success
          put :update, :id => @userstory, :userstory => @attr
        end

        it "should change the userstory's attributes" do
          put_update_success
          @userstory.reload
          @userstory.content.should  == @attr[:content]
        end

      end
    end
  end
  
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

      it "should destroy the userstory" do
        lambda do 
          delete :destroy, :id => @userstory
        end.should change(Userstory, :count).by(-1)
      end
    end
  end
  
end
