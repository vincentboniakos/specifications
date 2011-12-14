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
  
  describe "Userstory association" do
    before(:each) do
      @project = Factory(:project)
      first_feature = @project.features.create!({:name =>"First Awesome feature", :description => "This a description" })
      second_feature = @project.features.create!({:name =>"Second Awesome feature", :description => "This a description" })
      other_project = Factory(:project)
      @other_feature = Factory(:feature)
      @first_userstory = first_feature.userstories.create!({:content =>"First Awesome userstory"})
      @second_userstory = first_feature.userstories.create!({:content =>"Second Awesome userstory"})
      @other_userstory = @other_feature.userstories.create!({:content =>"Other Awesome userstory"})
    end
    
    it "should respond to userstories method" do
      @project.should respond_to(:userstories)
    end
    it "should return all the userstories of the project" do
      @project.userstories.find_all { |userstory| userstory == @first_userstory }.should_not be_nil
      @project.userstories.find_all { |userstory| userstory == @second_userstory }.should_not be_nil
    end
    it "should not return the userstories of an other project" do
      @project.userstories.find_all { |userstory| userstory == @other_userstory }.any?.should be_false
    end
  end

end
