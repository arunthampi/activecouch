require File.dirname(__FILE__) + '/spec_helper.rb'

describe "A subclass of ActiveCouch::Migration using define with two arguments" do
  before(:each) do
    class ByName < ActiveCouch::Migration
      define :by_name, :for_db => 'people' do
        with_key 'name'
      end
    end
  end
  
  it "should set the key correctly if the with_key method is called" do
    ByName.instance_variable_get("@key").should == 'name'
  end
  
  it "should set the database variable correctly" do
    ByName.instance_variable_get("@database").should == 'people'
  end
  
  it "should set the view instance variable correctly" do
    ByName.instance_variable_get("@view").should == 'by_name'
  end
  
  it "should generate the correct javascript to be used in the view" do
    (ByName.view_js =~ /map\(doc\.name, doc\);/).should_not == nil
  end
end

describe "A subclass of ActiveCouch::Migration with one argument" do

  before(:each) do
    class ByFace < ActiveCouch::Migration
      define :for_db => 'people' do
        with_key 'face'
      end
    end
  end

  it "should set the view instance variable correctly" do
    ByFace.instance_variable_get("@view").should == 'by_face'
  end

  it "should set the key correctly if the with_key method is called" do
    ByFace.instance_variable_get("@key").should == 'face'
  end
  
  it "should set the database variable correctly" do
    ByFace.instance_variable_get("@database").should == 'people'
  end
  
  it "should generate the correct javascript to be used in the view" do
    (ByFace.view_js =~ /map\(doc\.face, doc\);/).should_not == nil
  end
  
end

describe "A subclass of ActiveCouch::Migration with one argument" do
  
  before(:each) do
    class ByLatitude < ActiveCouch::Migration
      define :for_db => 'hotels' do
        with_key 'latitude'
        with_filter 'doc.name == "Hilton"'
      end
    end
  end
  
  it "should set the view instance variable correctly" do
    ByLatitude.instance_variable_get("@view").should == 'by_latitude'
  end
  
  it "should set the key correctly if the with_key method is called" do
    ByLatitude.instance_variable_get("@key").should == 'latitude'
  end
  
  it "should set the filter correctly" do
    ByLatitude.instance_variable_get("@filter").should == 'doc.name == "Hilton"'
  end
  
  it "should generate the correct javascript which will be used in the permanent view" do
    (ByLatitude.view_js =~ /map\(doc\.latitude, doc\);/).should_not == nil
    (ByLatitude.view_js =~ /if\(doc\.name == \\"Hilton\\"\)/).should_not == nil
  end
  
end

describe "A subclass of ActiveCouch::Migration with one argument" do
  before(:each) do
    class ByLongitude < ActiveCouch::Migration
      define :for_db => 'hotels' do
        with_key 'latitude'
        include_attributes :name, :rating, :latitude, :longitude, :address
      end
    end
  end
  
  it "should set the view instance variable correctly" do
    ByLongitude.instance_variable_get("@view").should == 'by_longitude'
  end
  
  it "should set the key correctly if the with_key method is called" do
    ByLongitude.instance_variable_get("@key").should == 'latitude'
  end

  it "should set the key correctly if the with_key method is called" do
    ByLongitude.instance_variable_get("@filter").should == nil
  end

  it "should generate the correct javascript which will be used in the permanent view" do
    (ByLongitude.view_js =~ /map\(doc\.latitude, \{name: doc\.name , rating: doc\.rating , latitude: doc\.latitude , longitude: doc\.longitude , address: doc\.address\}\);/).should_not == nil
  end
  
end