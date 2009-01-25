#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Type < DataMapper::Type
			
			# reject everything unless this
			# is overloaded by subclasses
			def self.typecast(value, property=nil)
				nil
			end
		end
	end
end

