#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/..")
require "#{root}/spec/helper.rb"

# define a familiar model with fuzzy
# types, to parse some crazy inputs
class Child
	include DataMapper::Resource
	include DataMapper::Fuzz

	property :id, Integer, :serial=>true
	property :name, String
	property :gender, Gender
	property :age, Age
end

describe DataMapper::Fuzz do
	describe "Properties" do
		it "should not interfere with DataMapper::Model#properties" do
			Child.properties.length.should == 4
		end
		
		it "should return fuzzable properties" do
			Child.fuzzables.length.should == 2
		end
	end
	
	describe "Parsing" do
		before(:each) do
			@child = Child.new
		end
		
		it "should reject junk data" do
			@child.parse("xyzzy").should == nil
		end
		
		it "should reject blank strings" do
			@child.parse("").should == nil
		end
		
		it "should extract a single property under ideal circumstances" do
			@child.parse("1 year old").should == true
			@child.age.should == Date.today - 365
		end
		
		it "should extract a single property from among junk data" do
			@child.parse("adam is 2 years old this week").should == true
			@child.age.should == Date.today - (365*2)
		end
		
		it "should store unparsed data" do
			@child.parse("evan thinks that he is 3 years old").should == true
			@child.unparsed.should == ["evan thinks that he is "]
		end
		
		it "should extract multiple properties under ideal circumstances" do
			@child.parse("male 4 years old").should == true
			@child.age.should == Date.today - (365*4)
			@child.gender.sould == :male
		end
		
		it "should extract multple properties out of order" do
			@child.parse("5 year old female").should == true
			@child.age.should == Date.today - (365*5)
			@child.gender.should == :female
		end
	end
end
