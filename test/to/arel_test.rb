require "test/test_helper"

require "predicated/to/arel"
include Predicated

apropos "convert a predicate to an arel where clause" do

  test "operations" do
    assert { Predicate{ Eq("a",1) }.to_arel == Arel::Equality.new("a", 1) }
    assert { Predicate{ Gt("a",1) }.to_arel == Arel::GreaterThan.new("a", 1) }
    assert { Predicate{ Lt("a",1) }.to_arel == Arel::LessThan.new("a", 1) }
    assert { Predicate{ Gte("a",1) }.to_arel == Arel::GreaterThanOrEqualTo.new("a", 1) }
    assert { Predicate{ Lte("a",1) }.to_arel == Arel::LessThanOrEqualTo.new("a", 1) }
  end

  test "simple and + or" do
    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_arel == 
              Arel::And.new(Arel::Equality.new("a", 1), Arel::Equality.new("b", 2)) }

    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_arel == 
              Arel::Or.new(Arel::Equality.new("a", 1), Arel::Equality.new("b", 2)) }
  end
  
  test "complex and + or" do
    assert { Predicate{ Or( And(Eq("a", 1),Eq("b", 2)), Eq("c", 3) ) }.to_arel ==
              Arel::Or.new(
                Arel::And.new(Arel::Equality.new("a", 1), Arel::Equality.new("b", 2)), 
                Arel::Equality.new("c", 3)
              ) }
  end

end