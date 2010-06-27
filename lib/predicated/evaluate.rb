module Predicated
  class Operation
    def evaluate(context=binding())
      left_processed = format_value(left, context)
      right_processed = format_value(right, context)
      code = "#{left_processed} #{sign} #{right_processed}"
      eval(code, context)
    end
    
    private 
    def format_value(thing, context)
      evaled = eval("return #{thing}", context)
      
      if evaled.is_a?(String) && evaled == thing
        %{"#{thing}"}
      else
        thing
      end
    end
  end
  
  class Equal < Operation; private; def sign; "==" end end
  class LessThan < Operation; private; def sign; "<" end end
  class GreaterThan < Operation; private; def sign; ">" end end
  class LessThanOrEqualTo < Operation; private; def sign; "<=" end end
  class GreaterThanOrEqualTo < Operation; private; def sign; ">=" end end

  module Container
    private 
    def boolean_or_evaluate(thing, context)
      if thing.is_a?(FalseClass)
        false
      elsif thing.is_a?(TrueClass)
        true
      else
        thing.evaluate(context)
      end
    end
  end
  
  class And
    include Container
    def evaluate(context=binding())
      boolean_or_evaluate(left, context) && boolean_or_evaluate(right, context)
    end 
  end
  
  class Or
    include Container
    def evaluate(context=binding())
      boolean_or_evaluate(left, context) || boolean_or_evaluate(right, context)
    end 
  end

end