module Predicated
  class Constraints
    def initialize
      @constraints = []
    end
    
    def <<(constraint)
      constraint[:selectors] ||= [:all]
      @constraints << constraint
      self
    end
    
    def check(whole_predicate)
      @constraints.collect do |constraint|
        whole_predicate.select(*constraint[:selectors]).collect do |predicate, ancestors|
          constraint[:check_that].call(predicate, ancestors)
        end.uniq == [true]
      end.flatten.uniq == [true]
    end
  end
end