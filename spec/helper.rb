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


# define a familiar model with fuzzy
# types, to parse some crazy inputs
class Child
	include DataMapper::Resource
	include DataMapper::Fuzz

	property :id, Integer, :serial=>true
	property :gender, Gender
	#property :height, Length
	#property :weight, Weight
	#property :muac, Length
end


# configure the database to a sqlite test db,
# and auto migrate it to clear existing data
DataMapper.setup(:default, "sqlite3:///tmp/dm-fuzz-test.db")
DataMapper.auto_migrate!
