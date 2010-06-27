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

  apropos "binding / context" do
    test "if we pass in a binding, that is the context for the evaluation" do
      x = 1
      assert { Predicate { eq(x, 1) }.evaluate(binding()) }
      deny { Predicate { eq(x, 2) }.evaluate(binding()) }
    
      a = "1"
      assert { Predicate { eq(a, "1") }.evaluate(binding()) }
      deny { Predicate { eq(a, "a") }.evaluate(binding()) }
      deny { Predicate { eq(a, 1) }.evaluate(binding()) }
      
      b = "b"
      assert { Predicate { eq(b, "b") }.evaluate(binding()) }
      assert { Predicate { eq(b, b) }.evaluate(binding()) }
      
      deny { Predicate { eq(a, b) }.evaluate(binding()) }
      b = "1"
      assert { Predicate { eq(a, b) }.evaluate(binding()) }
    end
  end

  apropos "comparing values of different data types" do
    test "strings" do
      assert { Predicate { eq("1", "1") }.evaluate }
      deny { Predicate { eq("1", 1) }.evaluate }
      deny { Predicate { eq("1", nil) }.evaluate }
    end
  
    test "numbers" do
      assert { Predicate { eq(1, 1) }.evaluate }
      assert { Predicate { eq(1, 1.0) }.evaluate }
      assert { Predicate { eq(1.0, 1.0) }.evaluate }
      deny { Predicate { eq(1, 2) }.evaluate }
      deny { Predicate { eq(1, nil) }.evaluate }
    end

    class Color
      attr_reader :name
      def initialize(name)
        @name
      end
    
      def ==(other)
        @name == other.name
      end
    end

    test "objects" do
      assert { Predicate { eq(Color.new("red"), Color.new("red")) }.evaluate }
      deny { Predicate { eq(Color.new("red"), Color.new("BLUE")) }.evaluate }
      deny { Predicate { eq(Color.new("red"), 2) }.evaluate }
      deny { Predicate { eq(Color.new("red"), "red") }.evaluate }
      deny { Predicate { eq(Color.new("red"), nil) }.evaluate }
    end
  end
end