require "rubygems"
require "minitest/spec"
require "assert2"

class MiniTest::Unit::TestCase
  include Test::Unit::Assertions  
end

MiniTest::Unit.autorun