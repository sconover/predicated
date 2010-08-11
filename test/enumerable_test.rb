require "test/test_helper_with_wrong"

require "predicated/predicate"
include Predicated

apropos "you can flip through the predicate tree, like any enumerable.  a list of ancestors of each node are provided" do
  
  test "simple" do
    assert { Predicate { Eq(1, 2) }.to_a == [[Predicate { Eq(1, 2) }, []]] }
  end
    
  test "complex" do
    the_top = Predicate { And(Eq(1, 2), Or(Eq(3, 4), Eq(5, 6))) }
    the_or = Predicate { Or(Eq(3, 4), Eq(5, 6)) }
    assert { the_top.to_a == 
       [
        [the_top, []],
        [Predicate { Eq(1, 2) }, [the_top]],
        [Predicate { Or(Eq(3, 4), Eq(5, 6)) }, [the_top]],
        [Predicate { Eq(3, 4) }, [the_top, the_or]],
        [Predicate { Eq(5, 6) }, [the_top, the_or]]
       ] 
     }
  end

  test "not" do
    the_top = Predicate { Not(Eq(1, 2)) }
    assert {  the_top.to_a == [[the_top, []], [Predicate { Eq(1, 2) }, [the_top]]] }
  end
    
end

apropos "there are convenient selectors defined for getting things out of a predicate" do
  class Array
    def predicates
      collect{|p, a|p}
    end
  end
  
  it "gets predicate parts by type" do
    root = Predicate { And(Eq(1, 2), Or(Eq(3, 4), Eq(5, 6))) }
    the_or = Predicate { Or(Eq(3, 4), Eq(5, 6)) }

    assert{ root.select(:all).predicates == [root, Equal.new(1, 2), the_or, Equal.new(3, 4), Equal.new(5, 6)] }
    
    assert{ root.select(And).predicates == [root] }
    assert{ root.select(Or).predicates == [the_or] }
    assert{ root.select(Equal).predicates == [Equal.new(1, 2), Equal.new(3, 4), Equal.new(5, 6)] }
    assert{ root.select(GreaterThan).predicates == [] }
    
    gt_lt = Predicate { And(Gt(1, 2), Lt(3, 4)) }
    assert{ gt_lt.select(GreaterThan).predicates == [GreaterThan.new(1, 2)] }
    assert{ gt_lt.select(LessThan).predicates == [LessThan.new(3, 4)] }

    gte_lte = Predicate { And(Gte(1, 2), Lte(3, 4)) }
    assert{ gte_lte.select(GreaterThanOrEqualTo).predicates == [GreaterThanOrEqualTo.new(1, 2)] }
    assert{ gte_lte.select(LessThanOrEqualTo).predicates == [LessThanOrEqualTo.new(3, 4)] }
    
    mixed = Predicate { And(Eq(1, 2), Or(Gt(3, 4), Lt(5, 6))) }
    mixed_or = Predicate { Or(Gt(3, 4), Lt(5, 6)) }
    assert{ mixed.select(Operation).predicates == [Equal.new(1, 2), GreaterThan.new(3, 4), LessThan.new(5, 6)] }
    assert{ mixed.select(Operation).select(Equal).predicates == [Equal.new(1, 2)] }
    assert{ mixed.select(Binary).predicates == [mixed, Equal.new(1, 2), mixed_or, GreaterThan.new(3, 4), LessThan.new(5, 6)] }
  end
end
