#!/usr/bin/env ruby
# vim: noet

root = File.expand_path(File.dirname(__FILE__) + "/..")
require "#{root}/spec/helper.rb"

class ABC < DataMapper::Fuzz::Type
	primitive String
	Pattern = '[abc]'
	
	def self.dumpable?(value)
		(value == "a") or (value == "b") or (value == "c")
	end
end

describe DataMapper::Fuzz::Type do
	it "rejects junk data" do
		ABC.typecast("").should == nil
		ABC.typecast("xyzzy").should == nil
		ABC.typecast(:mudkips).should == nil
		ABC.typecast(Object).should == nil
	end
	
	describe "Extracting" do
	end
end
