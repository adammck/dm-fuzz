#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe (gender = DataMapper::Fuzz::Gender) do
	describe "Matching" do
		it "rejects junk data" do
			gender.typecast(:hermaphrodite).should == nil
			gender.typecast("not a symbol").should == nil
			gender.typecast(0).should == nil
		end
		
		it "accepts a variety of gender formats" do
			examples = {
				:male    => :male,
				:female  => :female,
				"boy"    => :male,
				"girl"   => :female,
				"m"      => :male,
				"f"      => :female }
			
			examples.each do |val, out|
				gender.typecast(val).should == out
			end
		end
	end
	
	describe "Extracting" do
	end
	
	describe "Storage" do
		it "stores :male and :female as integers" do
			gender.dump(:male).should == 0
			gender.dump(:female).should == 1
		end
		
		it "loads 0 and 1 as symbols" do
			gender.load(0).should == :male
			gender.load(1).should == :female
		end
	end
end
