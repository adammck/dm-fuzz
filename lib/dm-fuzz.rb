#!/usr/bin/env ruby
# vim: noet

# import datamapper
require "rubygems"
require "dm-core"
require "dm-types"

# declare the module for
# everything to live in
module DataMapper
	module Fuzz
		
		def self.load_sample_models
			fuzz_root = File.expand_path(File.dirname(__FILE__) + "/..")
			Dir.glob("#{fuzz_root}/spec/models/*.rb").each do |path|
				require path
			end
		end
	end
end

# load all supporting files
dir = File.dirname(__FILE__)
require "#{dir}/dm-fuzz/type.rb"
require "#{dir}/dm-fuzz/types/gender.rb"
require "#{dir}/dm-fuzz/types/age.rb"
require "#{dir}/dm-fuzz/parser.rb"
