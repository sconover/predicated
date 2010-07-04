dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"
$LOAD_PATH.unshift "../wrong/lib"
require "rubygems"
require "minitest/spec"
require "pp"

#DO NOT REQUIRE WRONG IN HERE
#The circularity between projects will cause certain tests to not work.

class MiniTest::Unit::TestCase
  
  def assert_raise(exception_info_regex)
    begin
      yield
    rescue Exception => e
      assert{ exception_info_regex =~ "#{e.class.name} #{e.message}" }
    end
  end
  
end

module Kernel
  alias_method :apropos, :describe
  
  def xapropos(str)
    puts "x'd out 'apropos \"#{str}\"'"
  end
end

class MiniTest::Spec
  class << self
    alias_method :test, :it
    
    def xtest(str)
      puts "x'd out 'test \"#{str}\"'"
    end

  end
end

MiniTest::Unit.autorun