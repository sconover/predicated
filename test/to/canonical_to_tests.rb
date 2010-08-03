module CanonicalToTests
  
  module ClassMethods
    def create_canonoical_to_tests(to_expectations)
      tests = {
        "simple operations" => {
          "eq" => Predicate{ Eq("a",1) },
          "gt" => Predicate{ Gt("a",1) },
          "lt" => Predicate{ Lt("a",1) },
          "gte" => Predicate{ Gte("a",1) },
          "lte" => Predicate{ Lte("a",1) }
        }
      }
  
      tests.each do |test_name, cases|
        test test_name do
          
          not_found = 
            cases.keys.sort.reject{|case_name|to_expectations[test_name][case_name]}
          
          raise "no expectation defined for test: '#{test_name}'  cases: [#{not_found.join(", ")}]" unless not_found.empty?
          
          cases.each do |case_name, predicate|
            assert { yield(predicate) == to_expectations[test_name][case_name] }
          end
        end
      end
    end
  end
  
  def self.included(other)
    other.extend(ClassMethods)
  end
end