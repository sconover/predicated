require "test/test_helper_with_wrong"
require "net/http"
require "open-uri"

require "predicated/predicate"
require "predicated/to/solr"
include Predicated

def get_from_solr_using_predicate(predicate)
  eval(get_from_solr("/solr/select?q=#{URI.escape(predicate.to_solr)}&wt=ruby"))
end

def get_from_solr(path)
  open("http://localhost:8983#{path}").read
end

def post_to_solr(body)
  request = Net::HTTP::Post.new("/solr/update", {'Content-Type' =>'text/xml'})
  request.body = body
  response = Net::HTTP.new("localhost", 8983).start {|http| http.request(request) }
  raise "Response #{response.code}\n#{response.body}" unless response.code=="200"
end

apropos "solr is running properly" do
  test "solr schema is the one from this project" do
    assert{ get_from_solr("/solr/admin/file/?file=schema.xml") == File.read("test_integration/schema.xml") }
  end
end


apropos "predicates run against real solr" do
  before do
    unless @posted
      post_to_solr("<delete><query>*:*</query></delete>")
      post_to_solr("<commit/>")
      post_to_solr(%{
        <add>
          <doc>
            <field name="id">101</field>
            <field name="color_s">red</field>
            <field name="height_s">short</field>
            <field name="age_s">old</field>
            <field name="cats_i">0</field>
          </doc>
          <doc>
            <field name="id">102</field>
            <field name="color_s">blue</field>
            <field name="height_s">tall</field>
            <field name="age_s">old</field>
            <field name="cats_i">2</field>
          </doc>
          <doc>
            <field name="id">103</field>
            <field name="color_s">green</field>
            <field name="height_s">short</field>
            <field name="age_s">young</field>
            <field name="cats_i">3</field>
          </doc>
        </add>
      })
      post_to_solr("<commit/>")
    end
    @posted = true    
  end
  
  test "equal" do
    assert { get_from_solr_using_predicate(Predicate{ Eq("id",101) })["response"]["docs"].collect{|d|d["id"]} == ["101"] } 
    assert { get_from_solr_using_predicate(Predicate{ Eq("color_s","blue") })["response"]["docs"].collect{|d|d["id"]} == ["102"] } 
  end
  
  test "gt, lt, gte, lte" do
    assert { get_from_solr_using_predicate(Predicate{ Gt("cats_i",1) })["response"]["docs"].collect{|d|d["id"]}.sort == ["102", "103"] } 
    assert { get_from_solr_using_predicate(Predicate{ Lt("cats_i",3) })["response"]["docs"].collect{|d|d["id"]}.sort == ["101", "102"] } 
    assert { get_from_solr_using_predicate(Predicate{ Gte("cats_i",2) })["response"]["docs"].collect{|d|d["id"]}.sort == ["102", "103"] } 
    assert { get_from_solr_using_predicate(Predicate{ Lte("cats_i",2) })["response"]["docs"].collect{|d|d["id"]}.sort == ["101", "102"] } 
  end
  
  test "simple and + or" do
    assert { get_from_solr_using_predicate(Predicate{ And(Eq("height_s","tall"),Eq("age_s","old")) })["response"]["docs"].
              collect{|d|d["id"]} == ["102"] }     
    assert { get_from_solr_using_predicate(Predicate{ And(Eq("height_s","short"),Eq("age_s","old")) })["response"]["docs"].
              collect{|d|d["id"]} == ["101"] } 
              
    assert { get_from_solr_using_predicate(Predicate{ Or(Eq("height_s","short"),Eq("age_s","young")) })["response"]["docs"].
              collect{|d|d["id"]}.sort == ["101", "103"] } 
  end
  
  test "complex and + or" do
    assert { get_from_solr_using_predicate(
          Predicate{ Or(And(Eq("height_s","short"),Eq("age_s","young")),Eq("color_s","red")) })["response"]["docs"].
          collect{|d|d["id"]}.sort == ["101", "103"] } 

    assert { get_from_solr_using_predicate(
          Predicate{ Or(And(Eq("height_s","tall"),Eq("age_s","old")),Eq("color_s","green")) })["response"]["docs"].
          collect{|d|d["id"]}.sort == ["102", "103"] } 
  end

end