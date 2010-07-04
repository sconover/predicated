require "test/test_helper"

require "predicated/from/ruby_string"
include Predicated

apropos "parse a ruby predicate string" do

  apropos "basic operations" do

    test "simple signs" do
      assert { Predicate.from_ruby_string("1==1") == Predicate{ Eq(1,1) } }
      assert { Predicate.from_ruby_string(" 1 == 1 ") == Predicate{ Eq(1,1) } }
      assert { Predicate.from_ruby_string("0<1") == Predicate{ Lt(0,1) } }
      assert { Predicate.from_ruby_string("2>1") == Predicate{ Gt(2,1) } }
      assert { Predicate.from_ruby_string("1<=1") == Predicate{ Lte(1,1) } }
      assert { Predicate.from_ruby_string("1>=1") == Predicate{ Gte(1,1) } }
    end
    
    test "primitive types" do
      assert { Predicate.from_ruby_string("false==true") == Predicate{ Eq(false,true) } }
      assert { Predicate.from_ruby_string("'yyy'=='zzz'") == Predicate{ Eq("yyy","zzz") } }
    end

    test "simple and + or" do
      assert { Predicate.from_ruby_string("1==1 && 2==2") == Predicate{ And(Eq(1,1),Eq(2,2)) } }
      assert { Predicate.from_ruby_string("1==1 and 2==2") == Predicate{ And(Eq(1,1),Eq(2,2)) } }
      assert { Predicate.from_ruby_string("1==1 || 2==2") == Predicate{ Or(Eq(1,1),Eq(2,2)) } }
    end

    class Color
      attr_reader :name
      def initialize(name)
        @name = name
      end
    
      def ==(other)
        other.is_a?(Color) && @name == other.name
      end
    end

    test "substitute in from the binding" do
      a = 1
      b = "1"
      c = "c"
      d = Color.new("purple")
      
      assert { Predicate.from_ruby_string("a==1", binding()) == Predicate{ Eq(1,1) } }
      assert { Predicate.from_ruby_string("b==1", binding()) == Predicate{ Eq("1",1) } }
      assert { Predicate.from_ruby_string("c==b", binding()) == Predicate{ Eq("c","1") } }
      assert { Predicate.from_ruby_string("d==d", binding()) == Predicate{ Eq(Color.new("purple"),
                                                                              Color.new("purple")) } }
      assert { Predicate.from_ruby_string("d==d", binding()).left === d }
      
      assert { Predicate.from_ruby_string("a==b && b==c", binding()) == 
                Predicate{ And(Eq(1,"1"),Eq("1","c")) } }
    end


    test "complex and + or" do
      assert { Predicate.from_ruby_string("1==1 && 2==2 || 3==3") == 
        Predicate{ Or( And(Eq(1,1),Eq(2,2)), Eq(3,3) ) } }
    end
    
    test "parens change precedence" do
      assert { Predicate.from_ruby_string("1==1 || 2==2 && 3==3") == 
        Predicate{ Or( Eq(1,1), And(Eq(2,2),Eq(3,3)) ) } }

      assert { Predicate.from_ruby_string("(1==1 || 2==2) && 3==3") == 
        Predicate{ And( Or(Eq(1,1),Eq(2,2)), Eq(3,3) ) } }
    end
    
    test "only pay attention to the final line" do
      #might hate myself one day for this.  but what else does it make sense to do?
      assert { Predicate.from_ruby_string("z=2\nb=5\n1==1") == Predicate{ Eq(1,1) } }
    end

  end
  
  apropos "errors" do
    test "can't parse" do
      assert_raise /ParseError/ do 
        Predicate.from_ruby_string("bad ruby @@@@@****()(((")
      end
    end
    
    test "predicates only" do
      assert_raise /DontKnowWhatToDoWithThisSexpError/ do 
        Predicate.from_ruby_string("a=1")
      end
    end
  end
end