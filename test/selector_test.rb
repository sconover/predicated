require "test/test_helper"

require "predicated/predicate"
require "predicated/selector"
include Predicated

apropos "part one: selectors on an array (simple enumerable).  proving them out more generally." do
  
  test %{selection basics.  
         btw people often remark that this kind of thing is jQuery-like.
         I keep thinking I got it from Eric Evans.} do
    arr = [1,2,"c",4,"e",6]
    arr.extend SelectorEnumerable(
      :strings => proc{|item|item.is_a?(String)}, 
      :numbers => proc{|item|item.is_a?(Numeric)}, 
      :less_than_3 => proc{|item|item < 3} 
    )
    
    assert{ arr.select(:strings) == ["c", "e"] }
    assert{ arr.select(:numbers) == [1,2,4,6] }
    assert{ arr.select(:numbers).select(:less_than_3) == [1,2] }
    
    assert_raise ArgumentError do
      arr.select(:less_than_3) 
      #because strings don't respond to <
      #...there's no substitute for knowing what you're doing.
    end
    
    #normal select still works
    assert{ arr.select{|item|item.is_a?(String)} == ["c", "e"] }
  end
    
  test %{memoizes.  
         Selector enumerable assumes an immutable collection.
         I'm going to use that assumption against it, and cleverly prove that memoization works.
         Others might choose to mock in similar circumstances.} do
    arr = [1,2,"c",4,"e",6]
    arr.extend SelectorEnumerable(
      :strings => proc{|item|item.is_a?(String)}, 
      :numbers => proc{|item|item.is_a?(Numeric)}, 
      :less_than_3 => proc{|item|item < 3} 
    )
    assert{ arr.select(:strings) == ["c", "e"] }
    
    arr << "zzz"
    
    assert{ arr.select(:strings) == ["c", "e"] }
  end
end