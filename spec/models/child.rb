#!/usr/bin/env ruby
# vim: noet

class Child
	include DataMapper::Resource
	include DataMapper::Fuzz

	property :id, Integer, :serial=>true
	property :name, String
	property :gender, Gender
	property :age, Age
end
