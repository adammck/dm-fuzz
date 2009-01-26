#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe (klass = DataMapper::Fuzz::Age) do
	it "rejects junk data" do
		klass.typecast("").should == nil
		klass.typecast("xyzzy").should == nil
		klass.typecast(:mudkips).should == nil
		klass.typecast(Object).should == nil
	end
	
	describe "Typecasting Examples" do
		klass::Examples.each do |value, output|
			it "accepts #{value.inspect}" do
				klass.typecast(value).should == output
			end
		end
	end
	
	describe "Extracting" do
		it "should extract a single property under ideal circumstances" do
			klass.extract("i am 1 years old today!").should ==\
				[(Date.today - 365), "i am#{0.chr}today!"]
		end
		
		it "should extract a single property from among junk data" do
			klass.extract("adam is 2 years old this week").should ==\
				[Date.today - (365*2), "adam is#{0.chr}this week"]
		end
		
		it "should modify the argument when calling #extract!" do
			str = "evan thinks that he is 3 years old"
			val = klass.extract!(str)
			
			val.should == (Date.today - (365*3))
			str.should == "evan thinks that he is"
		end
	end
end
