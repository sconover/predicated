module Predicated
  class Constraints
    def initialize
      @constraints = []
    end
    
    def add(check_proc, selectors=[:all])
      @constraints << {
        :selectors => selectors,
        :check_proc => check_proc
      }
      self
    end
    
    def check(whole_predicate)
      @constraints.collect do |constraint|
        whole_predicate.select(*constraint[:selectors]).collect do |predicate, ancestors|
          constraint[:check_proc].call(predicate, ancestors)
        end.uniq == [true]
      end.flatten.uniq == [true]
    end
  end
end