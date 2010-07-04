require "predicated/predicate"

require 'ruby_parser'
require 'ruby2ruby'

module Predicated
  module Predicate
    def self.from_ruby_string(ruby_predicate_string, context=binding())
      last_line = ruby_predicate_string.strip.split("\n").last
      sexp = RubyParser.new.process(last_line).to_a
      converter = SexpToPredicate.new(context)
      converter.convert(sexp)
    end
    
    class SexpToPredicate
      SIGN_TO_PREDICATE_CLASS = {
        :== => Equal,
        :> => GreaterThan,
        :< => LessThan,
        :>= => GreaterThanOrEqualTo,
        :<= => LessThanOrEqualTo,
      }
      
      def initialize(context)
        @context = context
      end
      
      def convert(sexp)
        first_element = sexp.first
        if first_element == :call
          sym, left, sign, right = sexp
          SIGN_TO_PREDICATE_CLASS[sign].new(
            eval(Ruby2Ruby.new.process(left), @context), 
            eval(Ruby2Ruby.new.process(right), @context)
          )
        elsif first_element == :and
          sym, left, right = sexp
          And.new(convert(left), convert(right))
        elsif first_element == :or
          sym, left, right = sexp
          Or.new(convert(left), convert(right))
        else
          raise DontKnowWhatToDoWithThisSexpError.new(sexp)
        end
      end
    end
    
    class DontKnowWhatToDoWithThisSexpError < StandardError
      def initialize(sexp)
        super("don't know what to do with #{sexp.inspect}")
      end
    end
  end
end