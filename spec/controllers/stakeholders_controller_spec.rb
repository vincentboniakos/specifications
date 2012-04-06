require 'spec_helper'

describe StakeholdersController do
  render_views

  before (:each) do
    @project = Factory(:project)
    @attr = {:user_id => Factory(:user)}
  end


  describe "GET 'index'" do

  end
  

  describe "POST 'create'" do

    def create_stakeholder
      xhr :post, :create, :project_id => @project.id, :stakeholder => @attr
    end

    describe "for non signed-in user" do
      it "should deny access" do
        create_stakeholder
        response.response_code.should == 403
      end
    end

    describe "for signed-in user" do
      before(:each) do
        @current_user = Factory(:user, :email => Factory.next(:email), :invitation => Factory(:invitation, :recipient_email =>  Factory.next(:email)))
        test_sign_in(@current_user)
      end

      describe "not stakeholder" do
        it "should deny access" do
          create_stakeholder
          response.response_code.should == 403
        end
      end

      describe "stakeholder" do

        before (:each) do
          @project.stakeholders.create!(:user_id => controller.current_user.id)
        end

        describe "failure" do 
          def create_stakeholder_fail_empty
            @wrong_stakeholder_empty = {:user_id => nil}
            xhr :post, :create, :project_id => @project, :stakeholder => @wrong_stakeholder_empty
          end

          it "should not create a stakeholder" do
            lambda do 
              create_stakeholder_fail_empty
            end.should_not change(Stakeholder, :count)
          end

          it "should tell it is a bad request when one field is empty" do
            create_stakeholder_fail_empty
            response.response_code.should == 400
          end


        end

        describe "succes" do
          it "should create a stakeholder" do
            lambda do 
              create_stakeholder
            end.should change(Stakeholder, :count).by(1)
          end
        end
      end
    end
  end


  describe "DELETE 'destroy'" do

    before (:each) do
      @stakeholder = @project.stakeholders.create!(@attr)
    end

    def delete_stakeholder
      xhr :delete, :destroy, :project_id => @project, :id => @stakeholder
    end

    describe "for a non signed in user" do

      it "should deny access" do
        delete_stakeholder
        response.response_code.should == 403
      end
    end

    describe "for a signed in user" do

      before(:each) do
        @current_user = Factory(:user, :email => Factory.next(:email), :invitation => Factory(:invitation, :recipient_email =>  Factory.next(:email)))
        test_sign_in(@current_user)
      end

      describe "not stakeholder" do
        it "should deny access" do
          delete_stakeholder
          response.response_code.should == 403
        end
      end

      describe "stakeholder" do

         before(:each) do
            @stakeholder_conflict = @project.stakeholders.create!(:user_id => controller.current_user.id)
          end 
        
        describe "failure" do 
         
          def delete_stakeholder_fail
            xhr :delete, :destroy, :project_id => @project, :id => @stakeholder_conflict.id
          end

          it "should not delete the stakeholder" do
            lambda do 
              delete_stakeholder_fail
            end.should_not change(Stakeholder, :count)
          end

          it "should tell there is a conflict when trying to delete the current user" do
            delete_stakeholder_fail
            response.response_code.should == 403
          end

        end

        describe "succes" do
          it "should delete a stakeholder" do
            lambda do 
              delete_stakeholder
            end.should change(Stakeholder, :count).by(-1)
          end
          it "should tell it a success" do
            delete_stakeholder
            response.response_code.should == 200
          end
        end
      end
      
    end
  end

end
