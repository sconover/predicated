require "./test/test_helper_with_wrong"

require "predicated/simple_templated_predicate"
require "predicated/autogen_call"

include Predicated

regarding "if an unknown shorthand method is invoked, assume it's meant to be a Call predicate" do

  test "generate a call predicate.  form is Verb(subject [, object...]) ==> subject.verb_lowercase_underscored([object...])" do
    assert{ Predicate { Include?("abc", "bc") } == Predicate { AutogenCall.new("abc", :include?, "bc") } }
    assert{ Predicate { Nil?(nil) } == Predicate { AutogenCall.new(nil, :nil?) } }
  end

  test "existing predicates are unaffected" do
    assert{ Predicate { Eq(1, 1) } == Predicate { Eq(1, 1) } }
  end
  
  test "works when nested too" do
    assert{ Predicate { And(Eq(1, 1),Include?("abc", "bc")) } ==  
              Predicate { And(Eq(1, 1),AutogenCall.new("abc", :include?, "bc")) } }
  end
  
  test "looks neato when used with currying" do
    assert{ SimpleTemplatedPredicate{ Or(Nil?,Include?("bc")) }.fill_in("abc") == 
      Predicate { Or(AutogenCall.new("abc", :nil?),AutogenCall.new("abc", :include?, "bc")) } }
  end
  
end
