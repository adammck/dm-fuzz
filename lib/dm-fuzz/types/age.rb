#!/usr/bin/env ruby
# vim: noet

require "date"

module DataMapper
	module Fuzz
		class Age < Type
			primitive Date
			
			Pattern = '(\d+)(?:\s*(years? old|years?|yrs?|months? old|months|days? old|days))'
			
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
			
			Examples = {
				"1 yrs"        => (Date.today - 365),
				"2 years old"  => (Date.today - 730),
				"3 months old" => (Date.today - 90) }
		end
	end
end
