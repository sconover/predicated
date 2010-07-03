require "predicated/predicate"

module Predicated
  class Operation
    def evaluate
      left.send(sign.to_sym, right)
    end
  end
  
  class Equal < Operation; private; def sign; "==" end end
  class LessThan < Operation; private; def sign; "<" end end
  class GreaterThan < Operation; private; def sign; ">" end end
  class LessThanOrEqualTo < Operation; private; def sign; "<=" end end
  class GreaterThanOrEqualTo < Operation; private; def sign; ">=" end end

  module Container
    private 
    def boolean_or_evaluate(thing)
      if thing.is_a?(FalseClass)
        false
      elsif thing.is_a?(TrueClass)
        true
      else
        thing.evaluate
      end
    end
  end
  
  class And
    include Container
    def evaluate
      boolean_or_evaluate(left) && boolean_or_evaluate(right)
    end 
  end
  
  class Or
    include Container
    def evaluate(context=binding())
      boolean_or_evaluate(left) || boolean_or_evaluate(right)
    end 
  end

end