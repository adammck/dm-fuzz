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
dir = File.dirname(__FILE__)
require "#{dir}/../lib/dm-fuzz.rb"
