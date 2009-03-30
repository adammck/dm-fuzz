#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe (age = DataMapper::Fuzz::Age) do
	describe "Matching" do
		it "rejects junk data" do
			age.typecast("this is not a valid age").should == nil
			age.typecast(:nor_is_this).should == nil
		end
	
		it "accepts a variety of age formats" do
			examples = {
				"1 yrs"        => (Date.today - 365),
				"1 month"      => (Date.today - 30),
				"2 years old"  => (Date.today - 730),
				"3 months old" => (Date.today - 90),
				"4"            => (Date.today - (365*4)) }
			
			examples.each do |val, out|
				age.typecast(val).should == out
			end
		end
	end
	
	describe "Extracting" do
		it "should extract a single property under ideal circumstances" do
			age.extract("1 year old").should == [(Date.today - 365), ""]
		end
		
		it "should extract a single property from among junk data" do
			age.extract("adam is 2 years old this week").should ==\
				[Date.today - (365*2), "adam is#{0.chr}this week"]
		end
	end
	
	describe "Storage" do
		it "stores ages as dates"
	end
end
