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
  
  def _test_failure
    first_test_line = caller.find{|line|line =~ /_test.rb/}
    file, failure_line_number = first_test_line.split(":",2)
    
    lines = File.readlines(file)
    line_number = failure_line_number.to_i - 1
    to_show = []
    begin
      line = lines[line_number]
      to_show.unshift(line)
      line_number -= 1
    end while !(line =~ /^\s+test[ ]+/)
    
    to_show[to_show.length-1] = to_show[to_show.length-1].chomp + 
      "      ASSERTION FAILURE #{file}:#{failure_line_number.to_i}\n"
    fail("assertion failure\n\n#{to_show.join}")
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