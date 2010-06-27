module Predicated
  def Predicate(&block)
    result = nil
    Module.new do
      extend Predicate      
      result = instance_eval(&block)
    end
    result
  end
  
  class Binary
    def initialize(left, right)
      @left = left
      @right = right
    end
    
    private
    def left; @left end
    def right; @right end
  end
  
  class Operation < Binary; end
  
  module Predicate
    [[:And, :And, Class.new(Binary)],
     [:Or, :Or, Class.new(Binary)],
     [:Equal, :Eq, Class.new(Operation)],
     [:LessThan, :Lt, Class.new(Operation)],
     [:GreaterThan, :Gt, Class.new(Operation)],
     [:LessThanOrEqualTo, :Lte, Class.new(Operation)],
     [:GreaterThanOrEqualTo, :Gte, Class.new(Operation)]].each do |operation_class_name, shorthand, class_object|
       Predicated.const_set(operation_class_name, class_object)
       class_object.instance_variable_set("@shorthand".to_sym, shorthand)
       class_object.class_eval do
         def self.shorthand
           @shorthand
         end
       end
       module_eval(%{
         def #{shorthand}(left, right)
           ::Predicated::#{operation_class_name}.new(left, right)
         end
       })
     end
  end
end

require "predicated/print"