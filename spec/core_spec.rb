require "spec/spec_helper"

require "predicated/predicate"

apropos "prove value equality" do
	include Predicated
	
	test "simple" do
		assert { Predicate { Eq(1, 1) } == Predicate { Eq(1, 1) } }
		deny { Predicate { Eq(1, 1) } == Predicate { Eq(1, 99) } }
	end
	
	test "complex" do
		assert { Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } ==
		         Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } }
		
		deny {   Predicate { And(Eq(1, 1), Or(Eq(2, 2), Eq(3, 3))) } ==
		         Predicate { And(Eq(1, 1), Or(Eq(2, 99), Eq(3, 3))) } }
	end

end


apropos "you can flip through the predicate tree, like any enumerable" do
  include Predicated
  
  test "simple" do
    assert { Predicate { Eq(1, 2) }.to_a == [Predicate { Eq(1, 2) }, 1, 2] }
  end
    
  test "complex" do
    assert { Predicate { And(Eq(1, 2), Or(Eq(3, 4), Eq(5, 6))) }.to_a == 
						 [
							Predicate { And(Eq(1, 2), Or(Eq(3, 4), Eq(5, 6))) },
							Predicate { Eq(1, 2) },
							1,
							2,
							Predicate { Or(Eq(3, 4), Eq(5, 6)) },
							Predicate { Eq(3, 4) },
							3,
							4,
							Predicate { Eq(5, 6) },
							5,
							6
						 ] 
					 }
  end

end