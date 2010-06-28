module Predicated
  class Constraint
    def initialize(args)
      @select = args[:select] || proc{|predicate, ancestors| true}
      @check_that = args[:check_that] || raise(":check_that required")
    end
    
    def check(predicate, ancestors)
      @select.call(predicate, ancestors) ?
        @check_that.call(predicate, ancestors) :
        true
    end
  end
  
  class Constraints
    def initialize
      @items = []
    end
    
    def <<(constraint)
      @items << constraint
      self
    end
    
    def check(whole_predicate)
      whole_predicate.collect do |predicate, ancestors|
        @items.collect{|constraint|constraint.check(predicate, ancestors)}.uniq == [true]
      end.uniq == [true]
    end
  end
end