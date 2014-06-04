#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('../', __FILE__)

require 'task'

module Backup

  HOME = File.expand_path('~/') + '/'

  def task(name: nil, dest: nil)
    t = Task.new(name, dest)
    yield t
    t.run
  end
  module_function :task

  eval(File.read(File.expand_path('../config.rb', __FILE__)))
end

