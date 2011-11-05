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

      describe "but not admin" do
        it "should deny access and explain the user he is not authorized to see the pending invitations" do
          get :index
          response.should redirect_to(root_path)
          flash[:error].should =~ /not authorized/i
        end
      end

      describe "and admin" do

        before(:each) do
          @user.toggle!(:admin)
          @invitation = Factory(:invitation, :recipient_email => "admin@example.com")
          @invitations = [@invitation]
          15.times do
            @invitations << Factory(:invitation, :recipient_email => Factory.next(:email))
          end
        end

        it "should be succesful" do 
          get :index
          response.should be_success
        end

        it "should have the right title" do
          get :index
          response.should have_selector("title", :content => "Pending invitations")
        end

        it "should display the invivation that have not been sent yet"

        it "should have an element for each invitation" do
          get :index
          @invitations[1..3].each do |invitation|
            response.should have_selector("li", :content => invitation.recipient_email)
          end
        end

        it "should paginate the invivations" do
          get :index
          response.should have_selector("nav.pagine")
          response.should have_selector("span.current", :content => "1")
          response.should have_selector("a", :href => "/invitations?page=2",
          :content => "2")
        end

        it "should display a delete link for each invitation" do
          get :index
          @invitations[0..3].each do |invitation|
            response.should have_selector("a", :href => invitation_path(invitation), :content => "Delete")
          end
        end

        it "should display a link to send an invitation to the recipient email" do
          get :index
          @invitations[0..3].each do |invitation|
            response.should have_selector("a", :href => invitation_path(invitation), :content => "Send Invitation")
          end
        end
      end
    end
  end
end
