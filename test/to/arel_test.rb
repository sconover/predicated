require "test/test_helper_with_wrong"

unless RUBY_VERSION=="1.8.6"
  
require "predicated/to/arel"
include Predicated

apropos "convert a predicate to an arel where clause" do
  
  class FakeEngine
    def connection
    end
    
    def table_exists?(name)
      true
    end
  end
  
  class FakeColumn
    attr_reader :name, :type
    def initialize(name, type)
      @name = name
      @type = type
    end
    
    def type_cast(value)
      value
    end
  end
  
  before do
    @table = Arel::Table.new(:widget, :engine => FakeEngine.new)
    Arel::Table.tables = [@table]
    @table.instance_variable_set("@columns".to_sym, [
      FakeColumn.new("a", :integer), 
      FakeColumn.new("b", :integer),
      FakeColumn.new("c", :integer)
    ])
  end

  test "operations" do
    assert { Predicate{ Eq("a",1) }.to_arel(@table) ==
      Arel::Predicates::Equality.new(@table.attributes["a"], 1) }
    assert { Predicate{ Gt("a",1) }.to_arel(@table) == 
      Arel::Predicates::GreaterThan.new(@table.attributes["a"], 1) }
    assert { Predicate{ Lt("a",1) }.to_arel(@table) == 
      Arel::Predicates::LessThan.new(@table.attributes["a"], 1) }
    assert { Predicate{ Gte("a",1) }.to_arel(@table) == Arel::Predicates::GreaterThanOrEqualTo.new(@table.attributes["a"], 1) }
    assert { Predicate{ Lte("a",1) }.to_arel(@table) ==
      Arel::Predicates::LessThanOrEqualTo.new(@table.attributes["a"], 1) }
  end

  test "simple and + or" do
    assert { Predicate{ And(Eq("a", 1),Eq("b", 2)) }.to_arel(@table) == 
              Arel::Predicates::And.new(
                Arel::Predicates::Equality.new(@table.attributes["a"], 1), 
                Arel::Predicates::Equality.new(@table.attributes["b"], 2)
              ) }

    assert { Predicate{ Or(Eq("a", 1),Eq("b", 2)) }.to_arel(@table) == 
              Arel::Predicates::Or.new(
                Arel::Predicates::Equality.new(@table.attributes["a"], 1), 
                Arel::Predicates::Equality.new(@table.attributes["b"], 2)
              ) }
  end
  
  test "complex and + or" do
    assert { Predicate{ Or( And(Eq("a", 1),Eq("b", 2)), Eq("c", 3) ) }.to_arel(@table) ==
              Arel::Predicates::Or.new(
                Arel::Predicates::And.new(
                  Arel::Predicates::Equality.new(@table.attributes["a"], 1), 
                  Arel::Predicates::Equality.new(@table.attributes["b"], 2)
                ), 
                Arel::Predicates::Equality.new(@table.attributes["c"], 3)
              ) }
  end

end

end