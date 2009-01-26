#!/usr/bin/env ruby
# vim: noet

fuzz_root = File.expand_path(File.dirname(__FILE__) + "/..")
require "#{fuzz_root}/spec/helper.rb"

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
			@child.parse("").should == nil
			@child.parse("xyzzy").should == nil
			@child.parse(:mudkips).should == nil
			@child.parse(Object).should == nil
		end
		
		it "should extract a single property under ideal circumstances" do
			@child.parse("male").should_not == nil
			@child.gender.should == :male
		end
		
		it "should extract multiple properties under ideal circumstances" do
			@child.parse("male 4 years old").should_not == nil
			@child.age.should == Date.today - (365*4)
			@child.gender.should == :male
		end
		
		it "should extract multple properties out of order" do
			@child.parse("5 year old female").should_not == nil
			@child.age.should == Date.today - (365*5)
			@child.gender.should == :female
		end
	end
end
