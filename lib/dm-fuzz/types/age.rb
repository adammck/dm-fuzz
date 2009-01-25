#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Age < Type
			primitive Date
			
			Examples = {
				"1"           => (Date.today - 365),
				"2 years old" => (Date.today - 730) }
		end
	end
end
