module Predicated
  def Predicate(&block)
    result = nil
    Module.new do
      extend Predicate      
      result = instance_eval(&block)
    end
    result
  end
  
  class Operation
    def initialize(left, right)
      @left = left
      @right = right
    end
    
    private
    
    def left; @left end
    def right; @right end
  end
  
  module Predicate
    {:Equal => :eq,
     :LessThan => :lt,
     :GreaterThan => :gt,
     :LessThanOrEqualTo => :lte,
     :GreaterThanOrEqualTo => :gte}.each do |operation_class_name, shorthand|
       Predicated.const_set(operation_class_name, Class.new(Operation))
       module_eval(%{
         def #{shorthand}(left, right)
           #{operation_class_name}.new(left, right)
         end
       })
     end
  end
end