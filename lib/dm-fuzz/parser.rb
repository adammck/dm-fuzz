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
			
			parsed = []
			
			# iterate this model's fuzzable properties, and further extract
			# _str_ via the Type class of each one. note that Type.extract!
			# is destructive, so _str_ is changing throughout this iterator
			self.class.fuzzables.each do |prop|
				unless(extracted = prop.type.extract!(str)).nil?
					attribute_set prop.name, extracted
					parsed.push(prop)
				end
			end
			
			# store the remains of the parsed data,
			# so it can be presented to the end user
			@unparsed = str.dup
			
			# return an array of the properties that were
			# updated, or nil (NOT empty array!) if none were
			(parsed.empty?) ? nil : parsed
		end
		
		# Returns an Array containing the parts
		# of the last string passed to _parse_
		# that were not captured and normalized
		# into dumpable values.
		#
		#   c = Child.new
		#
		#   c.parse("13 year old")
		#   c.unparsed => []
		#
		#   c.parse("13 blah blah")
		#   c.unparsed => ["blah blah"]
		#
		#   c.parse("blah 13 y/o blah")
		#   c.unparsed => ["blah", "blah"]
		#
		def unparsed
			@unparsed.split(Fuzz::Replacement)
		end
	end
end

