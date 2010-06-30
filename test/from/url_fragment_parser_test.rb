require "test/test_helper"

require "predicated/predicate"
require "predicated/from/url_fragment_parser"
include Predicated
include Predicated::From

apropos "parse a url fragment, the result is a parse tree" do
  
  before do
    @parser = TreetopUrlFragmentParser.new
  end

  apropos "basic operations" do
    
    test "simple operations" do
      tree = @parser.parse("a=1")
      
      assert{ tree.is_a?(Predicated::From::TreetopUrlFragment::Operation) }      
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
    
  end

  apropos "to predicate" do
    
    test "simple operations" do
      assert{ @parser.parse("a=1").to_predicate == Predicate{Eq("a", "1")} }
      assert{ @parser.parse("a>1").to_predicate == Predicate{Gt("a", "1")} }
      assert{ @parser.parse("a<1").to_predicate == Predicate{Lt("a", "1")} }
      assert{ @parser.parse("a>=1").to_predicate == Predicate{Gte("a", "1")} }
      assert{ @parser.parse("a<=1").to_predicate == Predicate{Lte("a", "1")} }
    end
    
  end
end