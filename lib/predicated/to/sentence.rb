require "predicated/predicate"
require "predicated/evaluate"

module Predicated
  
  {And => " and ",
   Or => " or "}.each do |predicated_class, joining_str|

     predicated_class.class_eval %{
      def to_sentence
        left.to_sentence + "#{joining_str}" + right.to_sentence
      end

      def to_negative_sentence
        "This is not true: " + to_sentence
      end
    }
  end
  
  class Operation
    CLASS_TO_PHRASE = {
      Equal => "equal to",
      GreaterThan => "greater than",
      LessThan => "less than",
      GreaterThanOrEqualTo => "greater than or equal to",
      LessThanOrEqualTo => "less than or equal to"
    }
    
    def to_sentence
      sentence("")
    end
    
    def to_negative_sentence
      sentence(" not")
    end
    
    private 
    
    def sentence(linking)
      format_value(left) + phrase(linking) + format_value(right)
    end
    
    def phrase(linking)
      " is#{linking} #{CLASS_TO_PHRASE[self.class]} "
    end
        
    def format_value(value)
      if value.is_a?(String)
        "'" + value.to_s + "'"
      elsif value.nil?
        "nil"
      elsif value.is_a?(Numeric) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
        value.to_s
      else
        "'" + value.inspect + "'"
      end
    end
  end
  
  class Call < Operation
    def phrase(linking)
      method_str = method_sym.to_s.sub("?", "")
      " does#{linking} #{method_str} "
    end
  end
  
end