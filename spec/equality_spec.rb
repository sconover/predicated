require "spec/spec_helper"

require "predicated/predicate"

apropos "prove value equality" do
  include Predicated
  
  test "simple" do
    assert { Predicate { Eq(1, 1) } == Predicate { Eq(1, 1) } }
    deny   { Predicate { Eq(1, 1) } == Predicate { Eq(1, 99) } }
  end
  
  test "complex" do
    assert { Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } ==
             Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } }
    
    deny {   Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } ==
             Predicate { And(Eq(1, 1), Or(Eq(2, 99), Eq(3, 3))) } }
  end

end