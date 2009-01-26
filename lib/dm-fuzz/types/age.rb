#!/usr/bin/env ruby
# vim: noet

require "date"

module DataMapper
	module Fuzz
		class Age < Type
			primitive Date
			
			Pattern = '(\d+)(?:\s*(years? old|years?|yrs?|months? old|months|days? old|days))'
			
			# Returns true if _value_ is already
			# a Date, and doesn't need parsing.
			def self.dumpable?(value)
				value.is_a?(Date)
			end
			
			# Given the strings captured by Pattern, returns
			# a Date containing the aproximate date of birth.
			def self.normalize(n_str, unit)
				
				# multiply the quantity based upon
				# the unit, in a very rough fashion
				multipliers = {
					"y" => 365,
					"m" => 30,
					"d" => 1 }
				
				# return a date object from the days ago
				Date.today - (n_str.to_i * multipliers[unit.to_s[0,1]])
			end
		end
	end
end
