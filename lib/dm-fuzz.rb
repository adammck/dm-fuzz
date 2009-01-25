#!/usr/bin/env ruby
# vim: noet

# declare the module for
# everything to live in
module DataMapper
	module Fuzz
		
	end
end

# load all supporting files
dir = File.dirname(__FILE__)
require "#{dir}/dm-fuzz/type.rb"
require "#{dir}/dm-fuzz/types/gender.rb"
require "#{dir}/dm-fuzz/types/age.rb"
