require 'spec_helper'

describe Project do
  before(:each) do
    @attr = {
      :name => "Darty Gaming",
      :description => "This project is an e-commerce website. It sales fantastic games !",
    }
  end

  it "should create a new instance given valid attributes" do
    Project.create!(@attr)
  end

  it "should require a name" do
    no_name_project = Project.new(@attr.merge(:name => ""))
    no_name_project.should_not be_valid
  end

  it "should reject duplicate names" do
    Project.create!(@attr)
    project_with_duplicate_name = Project.new(@attr)
    project_with_duplicate_name.should_not be_valid
  end

  it "should reject a name that is too long" do
    long_name = "a" * 51
    long_name_project = Project.new(@attr.merge(:name => long_name))
    long_name_project.should_not be_valid
  end
  
  it "should reject a description that is too long" do
    long_name = "a" * 513
    long_name_project = Project.new(@attr.merge(:description => long_name))
    long_name_project.should_not be_valid
  end

end
