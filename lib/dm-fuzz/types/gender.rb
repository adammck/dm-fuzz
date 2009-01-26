#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Gender < Type
			primitive Integer
			
			Pattern = "(male|man|boy|m)|(female|woman|girl|f)"
			StoreAs = [:male, :female]
			
			# Returns true if _value_ is ready
			# to be stored in the database.
			def self.dumpable?(value)
				StoreAs.include?(value)
			end
			
			# Given the strings captured by Pattern, returns
			# the strict representation of the captured gender.
			def self.normalize(male_str, female_str)
				(female_str && :female) || (male_str && :male) || nil
			end
			
			# Called by DM when _value is about to be stored
			# in the database (in this case, as an Integer).
			def self.dump(value, property=nil)
				StoreAs.index(value)
			end
			
			# Called by DM when the value produced by self.dump
			# is retrieved, and is ready to be converted back
			# into a more friendly data type.
			def self.load(value)
				StoreAs[value]
			end
			
			# a list of various things that should be
			# accepted by this type, for unit tests to
			# be automatically generated from
			Examples = {
				:male    => :male,
				:female  => :female,
				"boy"    => :male,
				"girl"   => :female,
				"m"      => :male,
				"f"      => :female,
				
				# these are NOT valid
				123      => nil,
				"alpha"  => nil,
				:bravo   => nil }
		end
	end
end
