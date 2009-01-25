#!/usr/bin/env ruby
# vim: noet

# import rspec
require "rubygems"
require "spec"

# and datamapper
require "dm-core"
require "dm-types"

# import dm-fuzz by relative path, so
# we don't accidentally test the gem
fuzz_root = File.expand_path(File.dirname(__FILE__) + "/..")
require "#{fuzz_root}/lib/dm-fuzz.rb"

# import some sample models to test on
DataMapper::Fuzz.load_sample_models
