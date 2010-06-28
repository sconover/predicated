require "test/test_helper"

require "predicated/predicate"
require "predicated/constraint"
include Predicated

apropos %{constraints are rules about the content and structure of predicates.
          a predicate might violate a constraint} do
  test "constraints - apply to each predicate" do
    constraints = 
      Constraints.new << 
        Constraint.new(
          :select => proc{|predicate, ancestors| predicate.is_a?(Operation)},
          :check_that => proc{|predicate, ancestors| predicate.right!=2}
        )
    
    assert{ constraints.check(Predicate{Eq(1,1)}) == true }
    deny  { constraints.check(Predicate{Eq(1,2)}) == true }
    
    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(1,3))}) == true }
    deny  { constraints.check(Predicate{And(Eq(1,1), Eq(1,2))}) == true }
  end
  
  test "constraints - apply each to each predicate" do
    constraints = 
      Constraints.new \
        << Constraint.new(
          :select => proc{|predicate, ancestors| predicate.is_a?(Operation)},
          :check_that => proc{|predicate, ancestors| predicate.right!=2}
        ) \
        << Constraint.new(
          :check_that => proc{|predicate, ancestors| ancestors.length<=2}
        )

    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(3,3))}) == true }
    deny  { constraints.check(Predicate{And(Eq(1,1), Eq(2,2))}) == true }
    
    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(3,3))}) == true }
    deny  { constraints.check(Predicate{Or(Or(And(Eq(1,1), Eq(3,3)), Eq(4,4)), Eq(5,5))}) == true }
  end
  
end