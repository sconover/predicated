require "test/test_helper_with_wrong"

require "predicated/selectable"

apropos "part one: selectors on an array (simple enumerable).  proving them out more generally." do
  before do
    @arr = [1,2,"c",4,"e",6]
    Predicated::Selectable.bless_enumerable(@arr,
      :strings => proc{|item|item.is_a?(String)}, 
      :numbers => proc{|item|item.is_a?(Numeric)}, 
      :less_than_3 => proc{|item|item < 3} 
    )
  end
  
  test %{selection basics.  
         People often remark that this kind of thing is jQuery-like.
         I keep thinking I got it from Eric Evans.} do
    assert{ @arr.select(:numbers) == [1,2,4,6] }
    assert{ @arr.select(:strings) == ["c","e"] }
    assert{ @arr.select(:numbers).select(:less_than_3) == [1,2] }
    
    assert do
      catch_raise{ @arr.select(:less_than_3) }.is_a?(ArgumentError)
      #because strings don't respond to <
      #...there's no substitute for knowing what you're doing.
    end
    
    #normal select still works
    assert{ @arr.select{|item|item.is_a?(String)} == ["c","e"] }
  end

  test "...selector name can be any object" do
    arr = [1,2,"c",4,"e",6]

    Predicated::Selectable.bless_enumerable(arr,
      String => proc{|item|item.is_a?(String)},
      Numeric => proc{|item|item.is_a?(Numeric)},
      :less_than_3 => proc{|item|item < 3}
    )

    assert{ arr.select(String) == ["c","e"] }
    assert{ arr.select(Numeric) == [1,2,4,6] }
    assert{ arr.select(Numeric).select(:less_than_3) == [1,2] }
  end
    
  test "chaining.  also works using varargs" do
    assert{ @arr.select(:numbers).select(:less_than_3) == [1,2] }
    assert{ @arr.select(:numbers, :less_than_3) == [1,2] }
  end
    
  test "extending twice is additive (not destructive)" do
    arr = [1,2,"c",4,"e",6]
    Predicated::Selectable.bless_enumerable(arr, :strings => proc{|item|item.is_a?(String)})
    Predicated::Selectable.bless_enumerable(arr, :numbers => proc{|item|item.is_a?(Numeric)})

    assert{ arr.select(:strings) == ["c","e"] }
    assert{ arr.select(:numbers) == [1,2,4,6] }
  end
    
  test "works as a macro" do
    class MyArray < Array
      include Predicated::Selectable
      selector :strings => proc{|item|item.is_a?(String)}
      selector :numbers => proc{|item|item.is_a?(Numeric)}
      selector :small => proc{|item|item.is_a?(Numeric) && item < 3},
        :big => proc{|item|item.is_a?(Numeric) && item >= 3}
    end
    
    arr = MyArray.new
    arr.replace([1,2,"c",4,"e",6])

    assert{ arr.select(:strings) == ["c","e"] }
    assert{ arr.select(:numbers) == [1,2,4,6] }
    assert{ arr.select(:small) == [1,2] }
    assert{ arr.select(:big) == [4,6] }
  end
    
  test %{memoizes.
         Selector enumerable assumes an immutable collection.
         I'm going to use that assumption against it, and cleverly prove that memoization works.
         (Others might choose to mock in similar circumstances.)} do
    assert{ @arr.select(:strings) == ["c","e"] }

    @arr << "zzz"

    assert{ @arr.select(:strings) == ["c","e"] }
  end
end
