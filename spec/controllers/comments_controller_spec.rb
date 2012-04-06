require 'spec_helper'

describe CommentsController do
  render_views

    ########################
  ### NOT STAKEHOLDER
  ########################
  ## You must be a stakeholder to create, update or destroy a userstory within a project


  describe "Not stakeholder" do

    before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
    end


    describe "DELETE 'destroy'" do
      it "sould deny access" do
        comment = Factory(:comment)
        xhr :delete, :destroy, :project_id => comment.userstory.feature.project, :userstory_id => comment.userstory, :id => comment
        response.should be_forbidden
      end
    end

    describe "POST 'create'" do
      it "sould deny access" do
        userstory = Factory(:userstory)
        attr = { :body => "My Comment" }
        xhr :post, :create, :comment => attr, :project_id => userstory.feature.project, :userstory_id => userstory
        response.should be_forbidden
      end
    end
  end

  describe "Stakeholder" do

    def create_stakeholder
      @userstory.feature.project.stakeholders.create!(:user_id => controller.current_user.id)
    end
  
    ######################
    ## DELETE DESTROY
    ######################
    
    describe "DELETE 'destroy'" do

      describe "for a non signed in user" do

        before(:each) do
           @comment = Factory(:comment)
        end

        it "should deny access" do
          delete :destroy, :project_id => @comment.userstory.feature.project, :userstory_id => @comment.userstory, :id => @comment
          response.should redirect_to(login_path)
        end
      end

      describe "for a signed in user" do

        before(:each) do
          @user = Factory(:user)
          test_sign_in(@user)
          @userstory = Factory(:userstory)
          create_stakeholder
          @mycomment = @userstory.comments.create!({:body => "A comment", :user_id => @user.id})
        end
        
        def delete_destroy_ajax comment
          xhr :delete, :destroy, :project_id => comment.userstory.feature.project, :userstory_id => comment.userstory, :id => comment
        end

        describe "failure" do
          before(:each) do
            @comment_from_other = @userstory.comments.create!({:body => "A comment", :user_id => Factory(:user,{:email => "test_destroy_comment@example.com"}).id})
          end

          it "should not destroy a comment that not belongs to me" do
            lambda do
              delete_destroy_ajax @comment_from_other
            end.should_not change(Comment, :count)

          end        

        end

        describe "success" do
          it "should destroy the comment using ajax" do
            lambda do 
              delete_destroy_ajax @mycomment
            end.should change(Comment, :count).by(-1)
          end
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
          post :create, :comment => @attr, :project_id => @userstory.feature.project, :userstory_id => @userstory
          response.should redirect_to(login_path)
        end
      end

      describe "for signed-in user" do
        before(:each) do
          @user = test_sign_in(Factory(:user))
          create_stakeholder
        end

        def post_create_ajax
          xhr :post, :create, :comment => @attr, :project_id => @userstory.feature.project, :userstory_id => @userstory
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
end
