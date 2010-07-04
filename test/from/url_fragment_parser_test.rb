require "test/test_helper"
require "wrong"
require "wrong/minitest"

require "predicated/predicate"
require "predicated/from/url_fragment_parser"
include Predicated
include Predicated::From

apropos "parse a url fragment, the result is a parse tree" do
  
  before do
    @parser = TreetopUrlFragmentParser.new
  end

  apropos "simple operations" do
    
    test "parse" do
      tree = @parser.parse("a=1")
      
      assert{ tree.is_a?(Predicated::From::TreetopUrlFragment::OperationNode) }      
      assert{ [tree.left_text, tree.sign_text, tree.right_text] == ["a", "=", "1"] }
      
      tree = @parser.parse("a>1")
      assert{ [tree.left_text, tree.sign_text, tree.right_text] == ["a", ">", "1"] }
      
      tree = @parser.parse("a<1")
      assert{ [tree.left_text, tree.sign_text, tree.right_text] == ["a", "<", "1"] }

      tree = @parser.parse("a>=1")
      assert{ [tree.left_text, tree.sign_text, tree.right_text] == ["a", ">=", "1"] }

      tree = @parser.parse("a<=1")
      assert{ [tree.left_text, tree.sign_text, tree.right_text] == ["a", "<=", "1"] }
    end
    
    test "...to predicate" do
      assert{ @parser.parse("a=1").to_predicate == Predicate{Eq("a", "1")} }
      assert{ @parser.parse("a>1").to_predicate == Predicate{Gt("a", "1")} }
      assert{ @parser.parse("a<1").to_predicate == Predicate{Lt("a", "1")} }
      assert{ @parser.parse("a>=1").to_predicate == Predicate{Gte("a", "1")} }
      assert{ @parser.parse("a<=1").to_predicate == Predicate{Lte("a", "1")} }
    end

  end

  apropos "simple and" do
    test "parse" do
      tree = @parser.parse("a=1&b=2")

      assert{ tree.is_a?(Predicated::From::TreetopUrlFragment::AndNode) }      
      assert{ [[tree.left.left_text, tree.left.sign_text, tree.left.right_text],
               [tree.right.left_text, tree.right.sign_text, tree.right.right_text]] == 
               [["a", "=", "1"], ["b", "=", "2"]] }      
    end
    
    test "...to predicate" do
      assert{ @parser.parse("a=1&b=2").to_predicate == Predicate{ And( Eq("a", "1"),Eq("b", "2") ) } }
    end
  end

  apropos "simple or" do
    test "parse" do
      tree = @parser.parse("a=1|b=2")

      assert{ tree.is_a?(Predicated::From::TreetopUrlFragment::OrNode) }      
      assert{ [[tree.left.left_text, tree.left.sign_text, tree.left.right_text],
               [tree.right.left_text, tree.right.sign_text, tree.right.right_text]] == 
               [["a", "=", "1"], ["b", "=", "2"]] }      
    end
    
    test "...to predicate" do
      assert{ @parser.parse("a=1|b=2").to_predicate == Predicate{ Or( Eq("a", "1"),Eq("b", "2") ) } }
    end
  end
  
  apropos "complex and/or" do
    test "many or's" do
      assert{ @parser.parse("a=1|b=2|c=3").to_predicate == 
        Predicate{ Or( Eq("a", "1"), Or(Eq("b", "2"),Eq("c", "3")) ) } }
    end

    test "many and's" do
      assert{ @parser.parse("a=1&b=2&c=3").to_predicate == 
        Predicate{ And( Eq("a", "1"), And(Eq("b", "2"),Eq("c", "3")) ) } }
    end

    test "mixed and/or" do
      assert{ @parser.parse("a=1|b=2&c=3").to_predicate == 
        Predicate{ Or( Eq("a", "1"), And(Eq("b", "2"),Eq("c", "3")) ) } }

      assert{ @parser.parse("a=1&b=2|c=3").to_predicate == 
        Predicate{ Or( And(Eq("a", "1"),Eq("b", "2")), Eq("c", "3") ) } }
    end
  end

  apropos "parens (force higher precedence)" do
    test "no effect" do
      str = "(a=1|b=2)|c=3"
      assert{ @parser.parse(str).to_predicate == 
        Predicate{ Or( Or(Eq("a", "1"),Eq("b", "2")), Eq("c", "3") ) } }
      
      str = "((a=1|b=2))|c=3"
      assert{ @parser.parse(str).to_predicate == 
        Predicate{ Or( Or(Eq("a", "1"),Eq("b", "2")), Eq("c", "3") ) } }
    end

    test "force precedence" do
      #before
      assert{ @parser.parse("a=1|b=2&c=3").to_predicate == 
        Predicate{ Or( Eq("a", "1"), And(Eq("b", "2"),Eq("c", "3")) ) } }
      
      #after
      assert{ @parser.parse("(a=1|b=2)&c=3").to_predicate == 
        Predicate{ And( Or(Eq("a", "1"),Eq("b", "2")), Eq("c", "3") ) } }
    end
  end

end