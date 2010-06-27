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

  class And
    def evaluate(context=binding())
      true_or_evaluate(left, context) && true_or_evaluate(right, context)
    end
    
    private 
    def true_or_evaluate(thing, context)
      thing==true || thing.evaluate(context)
    end
  end
end