require "spec/spec_helper"

require "predicated/predicate"
require "predicated/evaluate"

apropos "evaluating predicates" do
  include Predicated
  
  apropos "proving out basic operations" do
    test "equals" do
      assert { Predicate { eq(1, 1) }.evaluate }
      deny { Predicate { eq(1, 2) }.evaluate }
    end
    
    test "less than" do
      assert { Predicate { lt(1, 2) }.evaluate }
      deny { Predicate { lt(2, 2) }.evaluate }
      deny { Predicate { lt(3, 2) }.evaluate }
    end

    test "greater than" do
      deny { Predicate { gt(1, 2) }.evaluate }
      deny { Predicate { gt(2, 2) }.evaluate }
      assert { Predicate { gt(3, 2) }.evaluate }
    end

    test "less than or equal to" do
      assert { Predicate { lte(1, 2) }.evaluate }
      assert { Predicate { lte(2, 2) }.evaluate }
      deny { Predicate { lte(3, 2) }.evaluate }
    end
    
    test "greater than or equal to" do
      deny { Predicate { gte(1, 2) }.evaluate }
      assert { Predicate { gte(2, 2) }.evaluate }
      assert { Predicate { gte(3, 2) }.evaluate }
    end

  end

  apropos "bindings" do
    test "if we pass in a binding, that is the context for the evaluation" do
      x = 1
      assert { Predicate { eq(x, 1) }.evaluate(binding()) }
      deny { Predicate { eq(x, 2) }.evaluate(binding()) }
    end
  end

  apropos "different data types" do
    test "strings" do
      x = 1
      assert { Predicate { eq(x, 1) }.evaluate(binding()) }
      deny { Predicate { eq(x, 2) }.evaluate(binding()) }
    end
  end
end