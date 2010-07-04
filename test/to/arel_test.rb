require "test/test_helper_with_wrong"

unless RUBY_VERSION=="1.8.6"
  
require "predicated/to/arel"
include Predicated

apropos "convert a predicate to an arel where clause" do

  test "operations" do
    assert { Predicate{ Eq("a",1) }.to_arel == Arel::Predicates::Equality.new("a", 1) }
    assert { Predicate{ Gt("a",1) }.to_arel == Arel::Predicates::GreaterThan.new("a", 1) }
    assert { Predicate{ Lt("a",1) }.to_arel == Arel::Predicates::LessThan.new("a", 1) }
    assert { Predicate{ Gte("a",1) }.to_arel == Arel::Predicates::GreaterThanOrEqualTo.new("a", 1) }
    assert { Predicate{ Lte("a",1) }.to_arel == Arel::Predicates::LessThanOrEqualTo.new("a", 1) }
  end

  test "simple and + or" do
    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_arel == 
              Arel::Predicates::And.new(
                Arel::Predicates::Equality.new("a", 1), 
                Arel::Predicates::Equality.new("b", 2)
              ) }

    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_arel == 
              Arel::Predicates::Or.new(
                Arel::Predicates::Equality.new("a", 1), 
                Arel::Predicates::Equality.new("b", 2)
              ) }
  end
  
  test "complex and + or" do
    assert { Predicate{ Or( And(Eq("a", 1),Eq("b", 2)), Eq("c", 3) ) }.to_arel ==
              Arel::Predicates::Or.new(
                Arel::Predicates::And.new(
                  Arel::Predicates::Equality.new("a", 1), 
                  Arel::Predicates::Equality.new("b", 2)
                ), 
                Arel::Predicates::Equality.new("c", 3)
              ) }
  end

end

end