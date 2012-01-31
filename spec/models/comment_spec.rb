require 'spec_helper'

describe Comment do
  before(:each) do
  	@userstory = Factory(:userstory) 	
    @attr = {
      :body => "This is a comment"
  	}
  end

  it "should create a new instance given valid attributes" do
    @userstory.comments.create!(@attr)
  end

  describe "comment associations" do
    
    before(:each) do
      @comment = @userstory.comments.create!(@attr)
    end

    it "should have a userstory attribute" do
      @comment.should respond_to(:userstory)
    end

    it "should have a user attribute" do
      @comment.should respond_to(:user)
    end
    
    it "should have the right associated userstory" do
      @comment.userstory_id.should == @userstory.id
      @comment.userstory.should== @userstory
    end
  end


  describe "validations" do

    it "should require a userstory id" do
      Comment.new(@attr).should_not be_valid
    end

    it "should require nonblank body" do
      @userstory.comments.build(:body => "  ").should_not be_valid
    end
  end
end
