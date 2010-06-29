require "test/test_helper"

require "predicated/predicate"
require "predicated/constrain"
include Predicated

apropos %{constraints are rules about the content and structure of predicates.
          a predicate might violate a constraint} do
            
  before do
    @value_not_equal_to_two =
      Constraint.new(:name => "Value can't be two",
                     :selectors => [Operation],
                     :check_that => proc{|predicate, ancestors| predicate.right!=2})
                     
    @not_more_than_two_levels_deep =
      Constraint.new(:name => "Limited to two levels deep",
                     :check_that => proc{|predicate, ancestors| ancestors.length<=2})
  end
  
  test "apply to each predicate - simple" do
    constraints = Constraints.new.add(@value_not_equal_to_two)
    
    assert{ constraints.check(Predicate{Eq(1,1)}).pass? }
    deny  { constraints.check(Predicate{Eq(1,2)}).pass? }
    
    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(1,3))}).pass? }
    deny  { constraints.check(Predicate{And(Eq(1,1), Eq(1,2))}).pass? }
  end
  
  test "apply each to each predicate - many constraints" do
    constraints = 
      Constraints.new.
        add(@value_not_equal_to_two).
        add(@not_more_than_two_levels_deep)

    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(3,3))}).pass? }
    deny  { constraints.check(Predicate{And(Eq(1,1), Eq(2,2))}).pass? }
    
    assert{ constraints.check(Predicate{And(Eq(1,1), Eq(3,3))}).pass? }
    deny  { constraints.check(Predicate{Or(Or(And(Eq(1,1), Eq(3,3)), Eq(4,4)), Eq(5,5))}).pass? }
  end

  test "equality" do
    one = Constraint.new(:name => "Value can't be two",
                         :selectors => [Operation],
                         :check_that => proc{|predicate, ancestors| predicate.right!=2})
    two = Constraint.new(:name => "Value can't be two",
                         :selectors => [Operation],
                         :check_that => proc{|predicate, ancestors| predicate.right!=2})
    three = Constraint.new(:name => "Some other constraint",
                           :check_that => proc{|predicate, ancestors| false})
                           
    assert{ one == two }
    deny  { one == three }
  end

  test %{result contains information about whether the checks passed, 
         which constraints were violated, 
         along with the offending predicates} do
    constraints = Constraints.new.add(@value_not_equal_to_two)
    
    result = constraints.check(Predicate{Eq(1,1)})
    assert{ result.pass? }
    assert{ result.violations == {} }
    
    result = constraints.check(Predicate{And(Eq(1,1), And(Eq(2,2), Eq(3,2)))})
    deny  { result.pass? }
    assert{ 
      result.violations == {
        @value_not_equal_to_two => [Equal.new(2,2), Equal.new(3,2)]
      } 
    }
  end

  
end