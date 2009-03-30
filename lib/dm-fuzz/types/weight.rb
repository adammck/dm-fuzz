#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Weight < Type
			primitive Float
			
			Units = {
				
				# METRIC
				:gram  => ["g", "gram", "grams"],
				:kilo  => ["kg", "kilo", "kilos", "kilogram", "kilograms", "kilogramme", "kilogrammes"],
				:tonne => ["t", "tonne", "tonnes", 'metric\s+ton', 'metric\s+tons', "megagram", "megagrams"],
				
				# IMPERIAL
				:ounce => ["oz", "ounce", "ounces"],
				:pound => ["lb", "pound", "pounds"],
				:stone => ["st", "stone", "stones"]
			}
			
			
			Multipliers = {
				:gram  => 0.001,
				:kilo  => 1,
				:tonne => 1000,
				:ounce => 0.0283495231,
				:pound => 0.45359237,
				:stone => 6.35029318,
			}
			
			
			# build a pattern for this type: any digit,
			# followed by any of the supported units
			UnitsPattern = Units.values.flatten.join("|")
			Pattern = '(\d+(?:\.\d+)?)(?:\s*(' + UnitsPattern + '))'
			
			
			# Returns true if _value_ is already
			# a Float, and doesn't need parsing.
			def self.dumpable?(value)
				value.is_a?(Float)
			end
			
			
			# Overload the Fuzz::Type.typecast method, to intercept and cast
			# any numeric types to float before attempting to parse them.
			def self.typecast(value, property=nil)
				value.is_a?(Numeric) ? value.to_f : super
			end
      
			
			# Given the strings captured by Pattern, returns
			# a Float containing the weight in kilograms.
			def self.normalize(n_str, unit_str)
				
				# the pattern was matched, so we know that _unit_str_
				# is *somewhere* in _Units_. iterate to find a matching
				# pattern (or piece of one), and return as soon as possible
				Units.each do |unit, strs|
					strs.each do |str|
						if unit_str.match(/\A#{str}\Z/)
							return n_str.to_f * Multipliers[unit]
						end
					end
				end
				
				# if we have reached here, something has gone
				# terribly wrong. Pattern was matched, but we
				# weren't able to figure out which unit was
				# matched... it's a bug, so raise
				raise ArgumentError.new(
					"Couldn't find a valid Weight " +\
					"unit in #{unit_str.inspect}")
			end
		end
	end
end
