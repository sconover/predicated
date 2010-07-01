dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"
$LOAD_PATH.unshift "~/arel/lib"
require "rubygems"
require "minitest/spec"
require "assert2"

class MiniTest::Unit::TestCase
  include Test::Unit::Assertions  
end

module Kernel
  alias_method :apropos, :describe
end

class MiniTest::Spec
  class << self
    alias_method :test, :it
  end
end

MiniTest::Unit.autorun