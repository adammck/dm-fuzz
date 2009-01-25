#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Gender < DataMapper::Type
			primitive Integer
			
			# Called by DM when a property of this type is
			# set, and returns the value to be stored. Should
			# accept a wide range of junk, and return strict data
			def self.typecast(value, property)
				[:male, :female].include?(value) ? value : nil
			end
			
			# Called by DM when _value is about to be stored
			# in the database (in this case, as an Integer).
			def self.dump(value, property)
				(value == :male) ? 0 : 1
			end
			
			# Called by DM when the value produced by self.dump
			# is retrieved, and is ready to be converted back
			# into a more friendly data type.
			def self.load(value)
				(value == 0) ? (:male) : (:female)
			end
		end
	end
end
