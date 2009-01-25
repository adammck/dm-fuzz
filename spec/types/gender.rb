#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/../..")
require "#{root}/spec/helper.rb"

describe DataMapper::Fuzz::Gender do
	before(:each) do
		@child = Child.new
	end
	
	it "rejects junk data" do
		@child.gender = :hermaphrodite
		@child.gender.should == nil
	end
	
	it "accepts :male" do
		@child.gender = :male
		@child.gender.should == :male
	end
	
	it "accepts :female" do
		@child.gender = :female
		@child.gender.should == :female
	end
end
