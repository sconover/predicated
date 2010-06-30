require "test/test_helper"


require "predicated/from/url_fragment"
include Predicated

apropos "parse url fragments and convert them into predicates" do

  apropos "basic operations" do
    before do
      @converter = From::UrlFragment.new
    end
    
    test "simple signs" do
      assert { @converter.convert("a=1") == Predicate{ Eq("a","1") } }
      assert { @converter.convert("a<1") == Predicate{ Lt("a","1") } }
      assert { @converter.convert("a>1") == Predicate{ Gt("a","1") } }
      assert { @converter.convert("a<=1") == Predicate{ Lte("a","1") } }
      assert { @converter.convert("a>=1") == Predicate{ Gte("a","1") } }
    end
  end
end