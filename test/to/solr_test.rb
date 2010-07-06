require "test/test_helper_with_wrong"

require "predicated/to/solr"
include Predicated

apropos "convert a predicate to a solr query" do

  test "equal" do
    assert { Predicate{ Eq("a",1) }.to_solr == "a:1" }
  end
  
  test "gt, lt, gte, lte" do
    # assert { Predicate{ Gt("a",1) }.to_solr == "a:[2 TO *]" }
    # assert { Predicate{ Lt("a",1) }.to_solr == Arel::Predicates::LessThan.new("a", 1) }
    # assert { Predicate{ Gte("a",1) }.to_solr == Arel::Predicates::GreaterThanOrEqualTo.new("a", 1) }
    # assert { Predicate{ Lte("a",1) }.to_solr == Arel::Predicates::LessThanOrEqualTo.new("a", 1) }
  end

  test "simple and + or" do
    #parens are necessary around AND's in solr in order to force precedence
    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_solr == "(a:1 AND b:2)" }
    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_solr == "a:1 OR b:2" }
  end
  
  test "complex and + or" do
    assert { Predicate{ Or(And(Eq("a", 1),Eq("b", 2)), Eq("c",3)) }.to_solr == "(a:1 AND b:2) OR c:3" }
  end

end