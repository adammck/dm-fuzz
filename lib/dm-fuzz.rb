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

		# The character inserted in place of a Token
		# when it is plucked out of a string (to prevent
		# the surrounding text from being considered a
		# single token, when it is clearly not)
		Replacement = 0.chr

		# The regex chunk which is considered a valid
		# delimiter between tokens in a form submission.
		Delimiter = '\A|[\s;,\*]+|' + Replacement + '|\Z'
		
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
