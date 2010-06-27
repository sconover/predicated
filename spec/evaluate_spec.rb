require "spec/spec_helper"

require "predicated/evaluate"

apropos "evaluating predicates" do
  include Predicated
  
  apropos "proving out basic operations" do
    test "equals" do
      assert { Predicate { Eq(1, 1) }.evaluate }
      deny { Predicate { Eq(1, 2) }.evaluate }
    end
  
    test "less than" do
      assert { Predicate { Lt(1, 2) }.evaluate }
      deny { Predicate { Lt(2, 2) }.evaluate }
      deny { Predicate { Lt(3, 2) }.evaluate }
    end

    test "greater than" do
      deny { Predicate { Gt(1, 2) }.evaluate }
      deny { Predicate { Gt(2, 2) }.evaluate }
      assert { Predicate { Gt(3, 2) }.evaluate }
    end

    test "less than or equal to" do
      assert { Predicate { Lte(1, 2) }.evaluate }
      assert { Predicate { Lte(2, 2) }.evaluate }
      deny { Predicate { Lte(3, 2) }.evaluate }
    end
  
    test "greater than or equal to" do
      deny { Predicate { Gte(1, 2) }.evaluate }
      assert { Predicate { Gte(2, 2) }.evaluate }
      assert { Predicate { Gte(3, 2) }.evaluate }
    end
  end

  apropos "binding / context" do
    test "if we pass in a binding, that is the context for the evaluation" do
      x = 1
      assert { Predicate { Eq(x, 1) }.evaluate(binding()) }
      deny { Predicate { Eq(x, 2) }.evaluate(binding()) }
    
      a = "1"
      assert { Predicate { Eq(a, "1") }.evaluate(binding()) }
      deny { Predicate { Eq(a, "a") }.evaluate(binding()) }
      deny { Predicate { Eq(a, 1) }.evaluate(binding()) }
      
      b = "b"
      assert { Predicate { Eq(b, "b") }.evaluate(binding()) }
      assert { Predicate { Eq(b, b) }.evaluate(binding()) }
      
      deny { Predicate { Eq(a, b) }.evaluate(binding()) }
      b = "1"
      assert { Predicate { Eq(a, b) }.evaluate(binding()) }
      
      c = "true"
      assert { Predicate { Eq("true", c) }.evaluate(binding()) }
      deny { Predicate { Eq(true, c) }.evaluate(binding()) }
    end
  end

  apropos "comparing values of different data types" do
    test "strings" do
      assert { Predicate { Eq("1", "1") }.evaluate }
      deny { Predicate { Eq("1", 1) }.evaluate }
      deny { Predicate { Eq("1", nil) }.evaluate }
    end
  
    test "booleans" do
      assert { Predicate { Eq(true, true) }.evaluate }
      deny { Predicate { Eq(false, true) }.evaluate }
      
      deny { Predicate { Eq(false, nil) }.evaluate }
      deny { Predicate { Eq(true, nil) }.evaluate }
      
      deny { Predicate { Eq("false", false) }.evaluate }
      deny { Predicate { Eq("true", true) }.evaluate }
    end
  
    test "numbers" do
      assert { Predicate { Eq(1, 1) }.evaluate }
      assert { Predicate { Eq(1, 1.0) }.evaluate }
      assert { Predicate { Eq(1.0, 1.0) }.evaluate }
      deny { Predicate { Eq(1, 2) }.evaluate }
      deny { Predicate { Eq(1, nil) }.evaluate }
    end

    class Color
      attr_reader :name
      def initialize(name)
        @name = name
      end
    
      def ==(other)
        @name == other.name
      end
    end

    test "objects" do
      assert { Predicate { Eq(Color.new("red"), Color.new("red")) }.evaluate }
      deny { Predicate { Eq(Color.new("red"), Color.new("BLUE")) }.evaluate }
      deny { Predicate { Eq(Color.new("red"), 2) }.evaluate }
      deny { Predicate { Eq(Color.new("red"), "red") }.evaluate }
      deny { Predicate { Eq(Color.new("red"), nil) }.evaluate }
    end
  end
  
  
  apropos "and" do
    test "left and right must be true" do
      assert { Predicate { And( Eq(1, 1), Eq(2, 2)) }.evaluate }
      deny { Predicate { And( Eq(99, 1), Eq(2, 2)) }.evaluate }
      deny { Predicate { And( Eq(1, 1), Eq(99, 2)) }.evaluate }
    end

    test "simple true and false work too" do
      assert { Predicate { And( true, true ) }.evaluate }
      assert { Predicate { And( true, Eq(2, 2) ) }.evaluate }
      deny { Predicate { And( true, false ) }.evaluate }
      deny { Predicate { And( Eq(2, 2), false ) }.evaluate }
    end
    
    test "nested" do
      assert { Predicate { And( true, And(true, true) ) }.evaluate }
      deny { Predicate { And( false, And(true, true) ) }.evaluate }
      deny { Predicate { And( true, And(true, false) ) }.evaluate }
    end
  end
  
  apropos "or" do
    test "one of left or right must be true" do
      assert { Predicate { Or(true, true) }.evaluate }
      assert { Predicate { Or(true, false) }.evaluate }
      assert { Predicate { Or(false, true) }.evaluate }
      deny { Predicate { Or(false, false) }.evaluate }
    end
  end  
  
end