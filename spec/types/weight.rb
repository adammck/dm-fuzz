#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe (weight = DataMapper::Fuzz::Weight) do
	describe "Matching" do
		it "rejects junk data" do
			weight.typecast([:a, :b, :c]).should == nil
			weight.typecast("w00t").should == nil
			weight.typecast(:YO).should == nil
		end
	
		it "accepts a variety of metric weight formats" do
			examples = {
				"10kg"       => 10.0,
				"25.5kg"     => 25.0,
				"1.5 tonnes" => 1500.0,
				"2"          => 2
			}
			
			examples.each do |val, out|
				weight.typecast(val).should == out
			end
		end
		
		it "accepts and converts (to KG) a variety of imperial weight formats" do
			examples = {
				"50oz"      => 1.4174,
				"500 ounce" => 14.174,
				"10lb"       => 4.535,
				"15pounds"   => 6.803,
				"12 stone"   => 76.203
			}
			
			# check each example, but this time, allow
			# a little wiggle room for unit conversions
			examples.each do |val, out|
				weight.typecast(val).should be_close(out, 0.001)
			end
		end
	end
	
	describe "Extracting" do
		it "should extract a single lone property" do
			weight.extract("20kg").should == [20.0, ""]
		end
		
		it "should extract a single property from among junk data" do
			weight.extract("i weigh 12kg more than you").should ==\
				[12.0, "i weigh#{0.chr}more than you"]
		end
	end
end
