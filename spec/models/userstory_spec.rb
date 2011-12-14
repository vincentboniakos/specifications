require 'spec_helper'

describe Userstory do

  before(:each) do
    @feature = Factory(:feature)
    @attr = {:content =>"Awesome userstory"}
  end

  it "should create a new instance given valid attributes" do
    @feature.userstories.create!(@attr)
  end

  ###################################
  ## FEATURE ASSOCIATION
  ###################################

  describe "Feature associations" do
    
    before(:each) do
      @userstory = @feature.userstories.create(@attr)
    end

    it "should have a feature attribute" do
      @userstory.should respond_to(:feature)
    end
    
    it "should have the right associated project" do
      @userstory.feature_id.should == @feature.id
      @userstory.feature.should == @feature
    end
  end
  


  ###################################
  ## VALIDAIONS
  ###################################

  describe "validations" do

    it "should require a feature id" do
      Userstory.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @feature.userstories.build(:content => "  ").should_not be_valid
    end
    
    it "should reject long content" do
      @feature.userstories.build(:content => "a" * 251).should_not be_valid
    end

  end
  
  ## DELETE ON CASCADE
  describe 'delete a feature' do
    it "should  destroy all the associated userstories" do
      @userstory = @feature.userstories.create(@attr)
      lambda do
         @userstory.feature.destroy
      end.should change(Userstory, :count).by(-1)
    end
  end
end
