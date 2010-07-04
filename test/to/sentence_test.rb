require "test/test_helper_with_wrong"

require "predicated/to/sentence"
include Predicated

apropos "convert a predicate to an english sentence" do
  
  test "operations" do
    assert { Predicate{ Eq("a",1) }.to_sentence == "'a' is equal to 1" }
    assert { Predicate{ Gt("a",1) }.to_sentence == "'a' is greater than 1" }
    assert { Predicate{ Lt("a",1) }.to_sentence == "'a' is less than 1" }
    assert { Predicate{ Gte("a",1) }.to_sentence == "'a' is greater than or equal to 1" }
    assert { Predicate{ Lte("a",1) }.to_sentence == "'a' is less than or equal to 1" }

    assert { Predicate{ Eq("a",1) }.to_negative_sentence == "'a' is not equal to 1" }
    assert { Predicate{ Gt("a",1) }.to_negative_sentence == "'a' is not greater than 1" }
    assert { Predicate{ Lt("a",1) }.to_negative_sentence == "'a' is not less than 1" }
    assert { Predicate{ Gte("a",1) }.to_negative_sentence == "'a' is not greater than or equal to 1" }
    assert { Predicate{ Lte("a",1) } .to_negative_sentence == "'a' is not less than or equal to 1" }
  end
  
  test "primitive types" do
    assert { Predicate{ Eq("a",1) }.to_sentence == "'a' is equal to 1" }
    assert { Predicate{ Eq("a",nil) }.to_sentence == "'a' is equal to nil" }
    assert { Predicate{ Eq("a",true) }.to_sentence == "'a' is equal to true" }
  end
  
  test "complex types" do
    assert { Predicate{ Eq([1,2],{3=>4}) }.to_sentence == "'[1, 2]' is equal to '{3=>4}'" }
  end
  
  test "calls - question mark methods" do
    assert { Predicate{ Call("abc", :include?, "bc") }.to_sentence == 
      "'abc' does include 'bc'" }

    assert { Predicate{ Call("abc", :include?, "bc") }.to_negative_sentence == 
      "'abc' does not include 'bc'" }
  end
  
  test "simple and + or" do
    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_sentence == 
              "'a' is equal to 1 and 'b' is equal to 2" }

    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_sentence == 
              "'a' is equal to 1 or 'b' is equal to 2" }

    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_negative_sentence == 
              "This is not true: 'a' is equal to 1 and 'b' is equal to 2" }

    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_negative_sentence == 
              "This is not true: 'a' is equal to 1 or 'b' is equal to 2" }
  end

end