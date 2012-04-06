require 'spec_helper'

describe UserstoriesController do
  render_views
  
  before(:each) do
    @project = Factory(:project)
  end
  



  ########################
  ### NOT STAKEHOLDER
  ########################
  ## You must be a stakeholder to create, update or destroy a userstory within a project


  describe "Not stakeholder" do

    before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @userstory = Factory(:userstory)
    end

    describe "PUT 'update'" do
      it "sould deny access" do
        @attr = { :content => "New content"}
        xhr :put, :update, :project_id => @userstory.feature.project, :id => @userstory, :userstory => @attr
        response.should be_forbidden
      end
    end


    describe "DELETE 'destroy'" do
      it "sould deny access" do
        xhr :delete, :destroy, :project_id => @userstory.feature.project, :id => @userstory
        response.should be_forbidden
      end
    end

    describe "POST 'create'" do
      it "sould deny access" do
        @feature = Factory(:feature)
        @attr = { :content => "My userstory"}
        xhr :post, :create, :userstory => @attr, :feature_id => @feature, :project_id => @feature.project 
        response.should be_forbidden
      end
    end

    describe "POST 'sort'" do 
      it "sould deny access" do
        @feature = Factory(:feature)
        @param = { "0"=>"undefined"}
         xhr :post, :sort, :project_id => @feature.project.id, "#{@feature.id}" => @param
        response.should be_forbidden
      end
    end

    describe "GET 'show'" do
      it "sould deny access" do
        get :show, :id => @userstory, :project_id => @userstory.feature.project 
        response.should redirect_to(root_path)
        flash[:error].should =~ /You are not authorized to access this resource./i
      end
    end

  end

  #########################
  #### PUT UPDATE
  #########################

  describe "Stakeholder" do

    def create_stakeholder
      @userstory.feature.project.stakeholders.create!(:user_id => controller.current_user.id)
    end


    describe "PUT 'update'" do

      before(:each) do
        @userstory = Factory(:userstory)
      end

      describe "for non signed-in user" do
        it "should deny access" do
          @attr = { :content => "New content"}
          put :update, :project_id => @userstory.feature.project, :id => @userstory, :userstory => @attr
          response.should redirect_to(login_path)
        end
      end
      describe "for signed-in user" do
        before(:each) do
          @user = Factory(:user)
          test_sign_in(@user)
          create_stakeholder
        end
        
        def put_update_ajax
          xhr :put, :update, :project_id => @userstory.feature.project, :id => @userstory, :userstory => @attr
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

          it "should be success" do
            put_update_ajax
            response.should be_success
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
          delete :destroy, :project_id => @userstory.feature.project, :id => @userstory
          response.should redirect_to(login_path)
        end
      end

      describe "for a signed in user" do

        before(:each) do
          @user = Factory(:user)
          test_sign_in(@user)
          @userstory = Factory(:userstory)
          create_stakeholder
        end
        
        def delete_destroy_ajax
          xhr :delete, :destroy, :project_id => @userstory.feature.project, :id => @userstory
        end

        it "should destroy the userstory using ajax" do
          lambda do 
            delete_destroy_ajax
          end.should change(Userstory, :count).by(-1)
        end

        it "should not destroy the entire project" do
          lambda do 
            delete_destroy_ajax
          end.should_not change(Project, :count)
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
          @project.stakeholders.create!(:user_id => controller.current_user.id)
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
            end.should change(Userstory, :count).by(1)
          end
        end
      end
    end
    
    ############################
    ## POST SORT 
    ############################
    describe "POST 'sort'" do 
      before (:each) do 
        @user = Factory(:user)
        test_sign_in(@user)
        @feature = Factory(:feature)
        @first_userstory = @feature.userstories.create!({:content => "First User story", :position => 1 })
        @second_userstory = @feature.userstories.create!({:content => "Second User story", :position => 2 })
        @param = { "0"=>"undefined", "1"=> @second_userstory.id, "2"=> @first_userstory.id }
      end
      
      def post_sort
        xhr :post, :sort, :project_id => @feature.project.id, "#{@feature.id}" => @param
      end
      it "should change the position of the userstories" do
        post_sort
        @first_userstory.reload().position.should > @second_userstory.reload().position
      end
    end

    ############################
    ## GET SHOW
    ############################
    describe "GET 'show'" do
      before(:each) do
        @userstory = Factory(:userstory)
      end

      def get_show
        get :show, :id => @userstory, :project_id => @userstory.feature.project 
        
      end

      describe "for non signed-in user" do
        it "should deny access" do
          get_show
          response.should redirect_to(login_path)
        end
      end
      
      describe "for signed-in user" do

        before(:each) do
          @user = test_sign_in(Factory(:user))
          create_stakeholder
        end

        it "should be successful" do
          get_show
          response.should be_success
        end

        it "should find the right userstory" do
          get_show
          assigns(:userstory).should == @userstory
        end

        it "should include the userstory's content" do
          get_show
          response.should have_selector("h1", :content => @userstory.content)
        end

        describe "comment" do
        
          before(:each) do
            @comment = @userstory.comments.create!({:body => "A comment", :user_id => Factory(:user,{:email => "test_comment@example.com"}).id})
            @owned_comment = Comment.create!({:body => "A comment owned", :userstory_id => @userstory.id, :user_id => @user.id})
            @other_comment = Factory(:userstory).comments.create!({:body => "A other comment", :user_id => Factory(:user,{:email => "test_comment_2@example.com"}).id})
          end  
        

          it "should display the comment of the userstory" do
            get_show
            response.should have_selector("p", :content => @comment.body)
          end

          it "should display a delete comment link only if the current user is the author of the comment" do
            get_show
            response.should_not have_selector("a.delete", :href => project_userstory_comment_path(@userstory.feature.project, @userstory,@comment))
            response.should have_selector("a.delete", :href => project_userstory_comment_path(@userstory.feature.project, @userstory,@owned_comment))
          end

          it "should not display the comment of another userstory" do
            get_show
            response.should_not have_selector("p", :content => @other_comment.body)
          end
        end
      end
    end
  end

end
