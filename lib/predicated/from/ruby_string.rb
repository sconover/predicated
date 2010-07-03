require "predicated/predicate"

require 'ruby_parser'

module Predicated
  module Predicate
    def self.from_ruby_string(ruby_predicate_string, context=binding())
      sexp = RubyParser.new.process(ruby_predicate_string).to_a
      
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
            operation_part(left), 
            operation_part(right)
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
      
      private
      def operation_part(sexp)
        first_element = sexp.first
        
        if first_element == :call
          name = sexp[2].to_s #[:call, nil, :aaa, [:arglist]]
          eval(name, @context)
        elsif first_element == :arglist
          literal = sexp[1] #[:arglist, [:lit, 999]]          
          operation_part(literal)
        elsif first_element == :lit || first_element == :str
          value = sexp[1] #[:lit, 999]
          value
        elsif first_element == :true
          true #[:true]
        elsif first_element == :false
          false #[:false]
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