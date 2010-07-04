require "test/test_helper"
require "wrong"
require "wrong/minitest"

require "predicated/from/url_fragment"
include Predicated

apropos "parse url fragments and convert them into predicates" do

  apropos "basic operations" do

    test "simple signs" do
      assert { Predicate.from_url_fragment("a=1") == Predicate{ Eq("a","1") } }
      assert { Predicate.from_url_fragment("a<1") == Predicate{ Lt("a","1") } }
      assert { Predicate.from_url_fragment("a>1") == Predicate{ Gt("a","1") } }
      assert { Predicate.from_url_fragment("a<=1") == Predicate{ Lte("a","1") } }
      assert { Predicate.from_url_fragment("a>=1") == Predicate{ Gte("a","1") } }
    end

    test "simple and + or" do
      assert { Predicate.from_url_fragment("a=1&b=2") == Predicate{ And(Eq("a","1"),Eq("b","2")) } }
      assert { Predicate.from_url_fragment("a=1|b=2") == Predicate{ Or(Eq("a","1"),Eq("b","2")) } }
    end

    test "complex and + or" do
      assert { Predicate.from_url_fragment("a=1&b=2|c=3") == 
        Predicate{ Or( And(Eq("a","1"),Eq("b","2")), Eq("c","3") ) } }
    end
    
    test "parens change precedence" do
      assert { Predicate.from_url_fragment("a=1|b=2&c=3") == 
        Predicate{ Or( Eq("a","1"), And(Eq("b","2"),Eq("c","3")) ) } }

      assert { Predicate.from_url_fragment("(a=1|b=2)&c=3") == 
        Predicate{ And( Or(Eq("a","1"),Eq("b","2")), Eq("c","3") ) } }
    end

  end
end