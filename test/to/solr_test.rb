require "test/test_helper_with_wrong"
require "test/to/canonical_to_tests"

require "predicated/to/solr"
include Predicated

apropos "convert a predicate to a solr query" do
  include CanonicalToTests
  
  @to_expectations = {
    "simple operations" => {
      "eq" => "a:3",
      "gt" => "a:[4 TO *]",
      "lt" => "a:[* TO 2]",
      "gte" => "a:[3 TO *]",
      "lte" => "a:[* TO 3]"
    },
    "simple and / or" => {
      #parens are necessary around AND's in solr in order to force precedence
      "and" => "(a:1 AND b:2)",
      "or" => "a:1 OR b:2",
    },
    "complex and / or" => {
      "or and" => "(a:1 AND b:2) OR c:3"
    }
  }
  
  create_canonoical_to_tests(@to_expectations) do |predicate|
    predicate.to_solr
  end

end