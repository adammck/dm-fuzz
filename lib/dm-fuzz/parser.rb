#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		
		# when this module is included in a model,
		# add some class methods, since they're
		# almost always required. i wonder why
		# ruby doesn't do this as default
		def self.included(mod)
			mod.extend(ClassMethods)
		end
		
		module ClassMethods
			def fuzzables
				properties.collect do |prop|
					prop if prop.type.ancestors.include?(DataMapper::Fuzz::Type)
				end.compact
			end
		end
		
		# Given an arbitrary string, attempt to populate
		# the fuzzable properties of this model using
		# heuristic magic.
		def parse(str)
			nil
		end
	end
end

