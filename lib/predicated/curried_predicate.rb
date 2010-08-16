require "predicated/predicate"
require "predicated/evaluate"

module Predicated
  def CurriedPredicate(&block)
    result = nil
    Module.new do
      extend CurriedShorthand
      result = instance_eval(&block)
    end
    result
  end
  
  class And
    def apply(replace_placeholder)
      And.new(left.apply(replace_placeholder), right.apply(replace_placeholder))
    end
  end
  
  class Or
    def apply(replace_placeholder)
      Or.new(left.apply(replace_placeholder), right.apply(replace_placeholder))
    end
  end
  
  class Not
    def apply(replace_placeholder)
      Not.new(inner.apply(replace_placeholder))
    end
  end
  
  class Operation
    def apply(replace_placeholder)
      self.class.new(replace_placeholder, right)
    end
  end
  
  class Call
    def apply(replace_placeholder)
      self.class.new(replace_placeholder, method_sym, right)
    end
  end
  
  module CurriedShorthand
    include Shorthand

    def Eq(right) ::Predicated::Equal.new(:placeholder, right) end
    def Lt(right) ::Predicated::LessThan.new(:placeholder, right) end
    def Gt(right) ::Predicated::GreaterThan.new(:placeholder, right) end
    def Lte(right) ::Predicated::LessThanOrEqualTo.new(:placeholder, right) end
    def Gte(right) ::Predicated::GreaterThanOrEqualTo.new(:placeholder, right) end    

    def Call(method_sym, right=[]) ::Predicated::Call.new(:placeholder, method_sym, right) end    
  end
  
end