#!/usr/bin/env ruby
# vim: noet

fuzz_root = File.expand_path(File.dirname(__FILE__) + "/..")
exec %Q<irb -r "#{fuzz_root}/lib/dm-fuzz.rb">
