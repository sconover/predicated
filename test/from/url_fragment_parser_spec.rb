require "test/test_helper"

require "predicated/predicate"
require "predicated/from/url_fragment_parser"
include Predicated

apropos "parse a url fragment, the result is a parse tree" do
  
  before do
    @parser = UrlFragmentParser.new
  end

  apropos "basic operations" do
    
    test "simple operations" do
      tree = @parser.parse("a=1")
      
      assert{ tree.is_a?(Predicated::UrlFragment::Operation) }      
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
end