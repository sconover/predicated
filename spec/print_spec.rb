require "spec/spec_helper"

require "predicated/predicate"

apropos "a predicate looks nice with you to_s it" do
  include Predicated
  
  test "numbers" do
    assert { Predicate { Eq(1, 1) }.to_s == "Eq(1,1)" }
    assert { Predicate { Lt(1, 2) }.to_s == "Lt(1,2)" }
  end
  
  test "booleans" do
    assert { Predicate { Eq(false, true) }.to_s == "Eq(false,true)" }
  end
  
  test "strings" do
    assert { Predicate { Eq("foo", "bar") }.to_s == "Eq('foo','bar')" }
  end

  class Color
    attr_reader :name
    def initialize(name)
      @name = name
    end
  
    def to_s
      "name:#{@name}"
    end
  end
    
  test "objects" do
    assert { Predicate { Eq(Color.new("red"), Color.new("blue")) }.to_s == "Eq(Color{'name:red'},Color{'name:blue'})" }
  end
  
  test "and, or" do
    assert { Predicate { And(true, false) }.to_s == "And(true,false)" }
    assert { Predicate { Or(true, false) }.to_s == "Or(true,false)" }
    
    assert { Predicate { And(Eq(1, 1) , Eq(2, 2)) }.to_s == "And(Eq(1,1),Eq(2,2))" }
    
    assert { Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) }.to_s == "And(Eq(1,1),Or(Eq(2,2),Eq(3,3)))" }
  end

end

apropos "a predicate looks nice with you inspect it" do
  include Predicated
end