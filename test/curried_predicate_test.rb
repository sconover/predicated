require "./test/test_helper_with_wrong"

require "predicated/curried_predicate"
include Predicated

regarding "curried predicates" do

  test "operations.  the left side is a placeholder" do
    assert{ CurriedPredicate{ Eq(1) }.apply(1) == Predicate { Eq(1, 1) } }
    assert{ CurriedPredicate{ Lt(2) }.apply(1) == Predicate { Lt(1, 2) } }
    assert{ CurriedPredicate{ Gt(1) }.apply(2) == Predicate { Gt(2, 1) } }
    assert{ CurriedPredicate{ Gte(1) }.apply(2) == Predicate { Gte(2, 1) } }
    assert{ CurriedPredicate{ Lte(2) }.apply(1) == Predicate { Lte(1, 2) } }

    assert{ CurriedPredicate{ Eq(true) }.apply(true) == Predicate { Eq(true, true) } }
  end
  
  test "and, or, not.  just pass on the apply" do
    assert{ CurriedPredicate{ And(Gt(3),Lt(5)) }.apply(4) == Predicate { And(Gt(4,3),Lt(4,5)) } }
    assert{ CurriedPredicate{ Or(Gt(3),Lt(5)) }.apply(4) == Predicate { Or(Gt(4,3),Lt(4,5)) } }
    assert{ CurriedPredicate{ Not(Gt(5)) }.apply(4) == Predicate { Not(Gt(4,5)) } }
  end
  
  test "call.  left side is a placeholder" do
    assert{ CurriedPredicate{ Call(:include?, "bc") }.apply("abc") == 
              Predicate { Call("abc", :include?, "bc") } }

    assert{ CurriedPredicate{ Call(:nil?) }.apply("abc") == 
              Predicate { Call("abc", :nil?) } }
  end
  
end
