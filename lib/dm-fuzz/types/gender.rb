#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Gender < Type
			primitive Integer
			
			Variants = {
				:male   => %w[male man boy m],
				:female => %w[female woman girl f]
			}
			
			Storage = {
				:male   => 0,
				:female => 1
			}
			
			# Called by DM when a property of this type is
			# set, and returns the value to be stored. Should
			# accept a wide range of junk, and return strict data
			def self.typecast(value, property=nil)
				Variants.each do |output, variants|
					return output if variants.include?(value.to_s)
				end
				
				# this value
				# isn't valid
				nil
			end
			
			# Called by DM when _value is about to be stored
			# in the database (in this case, as an Integer).
			def self.dump(value, property=nil)
				Storage[value]
			end
			
			# Called by DM when the value produced by self.dump
			# is retrieved, and is ready to be converted back
			# into a more friendly data type.
			def self.load(value)
				Storage.invert[value]
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
