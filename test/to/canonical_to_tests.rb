module CanonicalToTests
  
  module ClassMethods
    def create_canonoical_to_tests(to_expectations)
      tests = {
        "simple operations" => {
          "eq" => Predicate{ Eq("a",3) },
          "gt" => Predicate{ Gt("a",3) },
          "lt" => Predicate{ Lt("a",3) },
          "gte" => Predicate{ Gte("a",3) },
          "lte" => Predicate{ Lte("a",3) }
        },
        "simple and / or" => {
          "and" => Predicate{ And(Eq("a", 1),Eq("b", 2)) },
          "or" => Predicate{ Or(Eq("a", 1),Eq("b", 2)) }
        },
        "complex and / or" => {
          "or and" => Predicate{ Or(And(Eq("a", 1),Eq("b", 2)), Eq("c",3)) } 
        }
      }
  
      tests.each do |test_name, cases|
        test test_name do
          
          not_found = 
            cases.keys.sort.select do |case_name|
              to_expectations[test_name].nil? || 
              to_expectations[test_name][case_name].nil?
            end
          
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