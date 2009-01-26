#!/usr/bin/env ruby
# vim: noet

# check for a single argument
unless (type = ARGV[0])
	puts "Usage fail."
	exit
end

# import everything fuzz
fuzz_root = File.expand_path(File.dirname(__FILE__) + "/..")
require "#{fuzz_root}/lib/dm-fuzz.rb"
DataMapper::Fuzz::load_sample_models

# iterate all classes, and build a map of
# labels (least-significant constant parts)
# to the classes themselves -- but only for
# the classes we want to test (the sample
# models and fuzz property types)
types = {}
ObjectSpace.each_object(Class) do |klass|
	if klass.ancestors.include?(DataMapper::Fuzz::Type)\
	or klass.ancestors.include?(DataMapper::Fuzz)
		
		label = klass.to_s.downcase.scan(/[a-z]+\Z/).first
		types[label] = klass
	end
end

# check that the argument was the
# label of a class that we can test
unless (klass = types[type])
	puts "Argument fail."
	puts "Try: #{types.keys.join(",")}"
	exit
end

# loop forever, passing each
# input to the _test_ method,
# and printing the output
begin
	while(true)
		print "#{klass}> "
		str = STDIN.gets.strip
		puts "=> " + klass.test(str).inspect
	end

# quit with ctrl+c
rescue Interrupt
	puts "TTFN."
end
