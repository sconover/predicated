require "test/test_helper_with_wrong"

require "predicated/predicate"
require "predicated/to/arel"
include Predicated

require "sqlite3"
require "active_record"


def get_from_db_using_predicate(predicate)
  Table(:widget).where(predicate.to_arel(Table(:widget))).select.
    collect{|r|r.tuple}.
    collect{|d|d.first}
end

apropos "predicates run against a real db" do
  before do
    unless @created
      db_file = "/tmp/sqlite_db"
      FileUtils.rm_f(db_file)
      @db = SQLite3::Database.new(db_file)
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => db_file)
      @db.execute(%{
        create table widget (
          id INTEGER PRIMARY KEY, 
          eye_color VARCHAR(25), 
          height VARCHAR(25), 
          age VARCHAR(25), 
          cats NUMERIC);
      })
 
      @db.execute("insert into widget values (101, 'red', 'short', 'old', 0)")
      @db.execute("insert into widget values (102, 'blue', 'tall', 'old', 2)")
      @db.execute("insert into widget values (103, 'green', 'short', 'young', 3)")
    end
    @created = true    
  end
  
  test "equal" do
    assert { get_from_db_using_predicate(Predicate{ Eq("id",101) }) == [101] } 
    assert { get_from_db_using_predicate(Predicate{ Eq("eye_color","blue") }) == [102] } 
  end
  
  test "gt, lt, gte, lte" do
    assert { get_from_db_using_predicate(Predicate{ Gt("cats",1) }) == [102, 103] } 
    assert { get_from_db_using_predicate(Predicate{ Lt("cats",3) }) == [101, 102] } 
    assert { get_from_db_using_predicate(Predicate{ Gte("cats",2) }) == [102, 103] } 
    assert { get_from_db_using_predicate(Predicate{ Lte("cats",2) }) == [101, 102] } 
  end
  
  test "simple and + or" do
    assert { get_from_db_using_predicate(
      Predicate{And(Eq("height","tall"),Eq("age","old")) }) == [102] }     
    assert { get_from_db_using_predicate(
      Predicate{ And(Eq("height","short"),Eq("age","old")) }) == [101] } 
              
    assert { get_from_db_using_predicate(
      Predicate{Or(Eq("height","short"),Eq("age","young")) }).sort == [101, 103] } 
  end
  
  xtest "complex and + or" do
    assert { get_from_db_using_predicate(
          Predicate{ Or(And(Eq("height","short"),Eq("age","young")),Eq("color","red")) }) == 
            [101, 103] } 

    assert { get_from_db_using_predicate(
          Predicate{ Or(And(Eq("height","tall"),Eq("age","old")),Eq("color","green")) }) == 
            [102, 103] } 
  end

end