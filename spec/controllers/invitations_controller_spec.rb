require 'spec_helper'

describe InvitationsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    describe "for non signed-in user" do

      it "should be possible to ask for an invitation" do
        get :new
        response.should have_selector("input", :value => "Ask for an invitation")
      end
    end
    describe "for signed-in user" do
      before(:each) do
        test_sign_in(Factory(:user))
      end

      it "should be posible to send an invitation" do
        get :new
        response.should have_selector("input", :value => "Send an invitation")
      end
    end


  end

  describe "POST 'create'" do
    
    def post_create
      post :create, :invitation => @attr
    end

    describe 'failure' do

      before(:each) do
        @attr = {:recipient_email => ""}
      end

      it "should not create an invitation" do
        lambda do
          post_create
        end.should_not change(Invitation, :count)
      end
    
    end
    
    describe 'success' do

      before(:each) do
        @attr = {:recipient_email => "francis@example.com"}
      end

      it "should  create an invitation" do
        lambda do
          post_create
        end.should change(Invitation, :count)
      end
    
    end
  end

end
