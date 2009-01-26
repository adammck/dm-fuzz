#!/usr/bin/env ruby
# vim: noet

module DataMapper
	module Fuzz
		class Type < DataMapper::Type
			
			
			# When a fuzzy property is set, this method (of
			# the property's type) is called to translate the
			# loose value into something strict.
			#
			# c = Child.new
			# c.gender = "Boy"
			# c.gender => :male
			def self.typecast(value, property=nil)
				
				# refuse to set the property if the
				# value can't be matched against
				return nil unless\
					value.respond_to? :match
				
				# perform the match; if it's successful, normalize the
				# captured data, otherwise, refuse to set the property
				m = value.match(pattern)
				(m == nil) ? nil : normalize(*m.captures)
			end
			

			# Returns the pattern (a Regex) matched by this
			# class, or raises RuntimeError if none is available.
			# The _exclusive_ argument indicates whether the output
			# will only match an entire string (default), or whether
			# a fragment will suffice, surrounded by delimiters.
			def self.pattern(exclusive=true)
				raise RuntimeError.new("#{self} has no pattern")\
					unless self.const_defined?(:Pattern)

				# ruby doesn't consider the class body of
				# subclasses to be in this scope. weird.
				pat = const_get(:Pattern)

				# if the pattern contains no captures, wrap it in parenthesis
				# to capture the whole thing. this is vanity, so we can omit
				# the parenthesis from the patterns of simple tyoes
				pat = "(" + pat + ")"\
					unless pat.index "("

				# TODO: doc
				if exclusive
					rx = '\A' + pat + '\Z'
				
				else
					# build the patten wedged between delimiters,
					# to avoid matching within other token bodies
					del = "(?:" + DataMapper::Fuzz::Delimiter + ")"
				
					# wrap the pattern in delimiters,
					# to avoid matching within fields
					rx = del + pat + del
				end
				
				# return a regex object to match
				# incoming strings against
				Regexp.new(rx, Regexp::IGNORECASE)
			end
			
			
			# Extract this type's pattern from _str_, and
			# returns a two-element array containing the
			# normalized result and the remaining string.
			def self.extract(str)
				m = str.match(pattern(false))
				return nil if m.nil?
				
				# return the match data and _str_ with the matched
				# token replace by Fuzz::Replacement, to continue parsing
				join = ((!m.pre_match.empty? && !m.post_match.empty?) ? DataMapper::Fuzz::Replacement : "")
				[normalize(*m.captures), m.pre_match + join + m.post_match]
			end

			
			# Calls _extract_, but returns only a single
			# value (the normalized captures), and modified
			# the _str_ argument to remove the captured data.
			def self.extract!(str)

				# call Token#extract first,
				# and abort it if failed
				ext = extract(str)
				return nil\
					if ext.nil?

				# update the argument (the BANG warns
				# of the danger of this operation...)
				str.replace(ext[1])
				ext[0]
			end
		end
	end
end

