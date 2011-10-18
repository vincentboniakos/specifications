require 'spec_helper'

describe Feature do

  before(:each) do
    @project = Factory(:project)
    @attr = {:name =>"Awesome feature", :description => "This a description" }
  end

  it "should create a new instance given valid attributes" do
    @project.features.create!(@attr)
  end

  ###################################
  ## PROJECT ASSOCIATION
  ###################################

  describe "project associations" do
    
    before(:each) do
      @feature = @project.features.create(@attr)
    end

    it "should have a project attribute" do
      @feature.should respond_to(:project)
    end
    
    it "should have the right associated project" do
      @feature.project_id.should == @project.id
      @feature.project.should == @project
    end
  end


  ###################################
  ## VALIDAIONS
  ###################################

  describe "validations" do

    it "should require a project id" do
      Feature.new(@attr).should_not be_valid
    end

    it "should require nonblank name" do
      @project.features.build(:name => "  ").should_not be_valid
    end
    
    it "should reject long name" do
      @project.features.build(:name => "a" * 51).should_not be_valid
    end

    it "should reject long description" do
      @project.features.build(:description => "a" * 251).should_not be_valid
    end
  end
  
  ## DELETE ON CASCADE
  describe 'delete a project' do
    it "should destroy all the associated features" do
      @feature = @project.features.create(@attr)
      lambda do
        @feature.project.destroy
      end.should change(Feature, :count).by(-1)
    end
  end
end
