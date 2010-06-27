require "test/test_helper"

require "predicated/predicate"
# require "predicated/constraint"

apropos %{constraints are rules about the content and structure of predicates.
          a predicate might violate a constraint} do
  include Predicated
  
  test "simple" do
  end
end