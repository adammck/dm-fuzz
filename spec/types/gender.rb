#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe (klass = DataMapper::Fuzz::Gender) do
	it "rejects junk data" do
		klass.typecast(:hermaphrodite).should == nil
	end
	
	describe "Examples" do
		klass::Examples.each do |value, output|
			it "accepts #{value.inspect}" do
				klass.typecast(value).should == output
			end
		end
	end
	
	describe "Storage" do
		before(:each) do
			@c = Child.new
		end
		
		it "stores :male and :female as integers" do
			klass.dump(:male).should == 0
			klass.dump(:female).should == 1
		end
		
		it "loads 0 and 1 as symbols" do
			klass.load(0).should == :male
			klass.load(1).should == :female
		end
	end
end
