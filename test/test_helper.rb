dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../lib"
require "rubygems"
require "minitest/spec"
require "pp"

require "ruby2ruby"
require "ruby_parser"


# This is a snippet from my ~/.irbrc
# You need to gem install ruby2ruby ParseTree

# This is what you do with it
#
# > class Bar; define_method(:foo) { 'ou hai' }; end
# > puts Bar.to_ruby
# class Bar < Object
#   def foo
#     "ou hai"
#   end
# end

require 'ruby2ruby'
require 'sexp_processor'
require 'unified_ruby'
require 'parse_tree'

# # Monkey-patch to have Ruby2Ruby#translate with r2r >= 1.2.3, from
# # http://seattlerb.rubyforge.org/svn/ruby2ruby/1.2.2/lib/ruby2ruby.rb
# class Ruby2Ruby < SexpProcessor
#   def self.translate(klass_or_str, method = nil)
#     sexp = ParseTree.translate(klass_or_str, method)
#     unifier = Unifier.new
#     unifier.processors.each do |p|
#       p.unsupported.delete :cfunc # HACK
#     end
#     sexp = unifier.process(sexp)
#     self.new.process(sexp)
#   end
# end
# 
# # The Beef
# class Module
#   def to_ruby
#     Ruby2Ruby.translate(self)
#   end
# end

  #   c = Class.new
  #   c.class_eval do
  #     define_method :serializable, &block
  #   end
  #   s = Ruby2Ruby.translate(c, :serializable)    
  # p s
  # p RubyParser.new.process(s)

class MiniTest::Unit::TestCase
  
  def assert(&block)
    yield || _test_failure
  end
  
  def deny
    yield && _test_failure
  end
  
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