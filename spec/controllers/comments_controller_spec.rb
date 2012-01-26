require 'spec_helper'

describe CommentsController do
  render_views

  
  
  ######################
  ## DELETE DESTROY
  ######################
  
  describe "DELETE 'destroy'" do

    describe "for a non signed in user" do

      before(:each) do
         @comment = Factory(:comment)
      end

      it "should deny access" do
        delete :destroy, :userstory_id => @comment.userstory, :id => @comment
        response.should redirect_to(login_path)
      end
    end

    describe "for a signed in user" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @comment = Factory(:comment)
      end
      
      def delete_destroy_ajax
        xhr :delete, :destroy, :userstory_id => @comment.userstory, :id => @comment
      end

      it "should destroy the comment using ajax" do
        lambda do 
          delete_destroy_ajax
        end.should change(Comment, :count).by(-1)
      end
    end
  end
  
  #########################
  ## POST CREATE
  #########################
  describe "POST 'create'" do

    before (:each) do 
      @userstory = Factory(:userstory)
      @attr = { :content => "My coment"}
    end

    describe "for non signed-in user" do
      it "should deny access" do
        post :create, :comment => @attr, :userstory_id => @userstory
        response.should redirect_to(login_path)
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
      end

      def post_create_ajax
        xhr :post, :create, :comment => @attr, :userstory_id => @userstory
      end


      describe "failure" do

        before(:each) do
          @attr = { :body => ""}
        end

        it "should not create a user story using ajax" do
          lambda do
            post_create_ajax
          end.should_not change(Comment, :count)
        end

      end

      describe "success" do

        before(:each) do
          @attr = { :body => "My Comment" }
        end

        it "should create a comment using Ajax" do
          lambda do
            post_create_ajax
            response.should be_success
          end.should change(Comment, :count).by(1)
        end
      end
    end
  end
  
end
