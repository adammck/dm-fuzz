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
			
			# it's okay if the argument can't
			# be matched against (it might be
			# a nil, or some other junk). just
			# return nil (no matches)
			return nil unless\
				str.respond_to? :match
			
			#matches = {}
			return nil
			
			# iterate this model's fuzzable properties, and further extract
			# _str_ via the Type class of each one. note that Type.extract!
			# is destructive, so _str_ is changing throughout this iterator
			self.class.fuzzables.each do |prop|
				unless(extracted = prop.type.extract!(str)).nil?

				end
			end
			
			self.class.fuzzables.collect do |prop|
				prop.type
			end
		end
	end
end

