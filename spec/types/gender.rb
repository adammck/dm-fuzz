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
end
