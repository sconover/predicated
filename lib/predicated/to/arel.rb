raise "this doesn't work in 1.8.6 because the arel gem is 1.8.7-only" if RUBY_VERSION=="1.8.6"

require "predicated/predicate"

module Predicated
  
  require_gem_version("arel", "0.4.0")
  
  {And => Arel::Predicates::And,
   Or => Arel::Predicates::Or}.each do |predicated_class, arel_class|

     predicated_class.class_eval %{
      def to_arel
        #{arel_class.name}.new(left.to_arel, right.to_arel)
      end
    }
     

  end
  
  {Equal => Arel::Predicates::Equality,
   GreaterThan => Arel::Predicates::GreaterThan,
   LessThan => Arel::Predicates::LessThan,
   GreaterThanOrEqualTo => Arel::Predicates::GreaterThanOrEqualTo,
   LessThanOrEqualTo => Arel::Predicates::LessThanOrEqualTo}.each do |predicated_class, arel_class|

    predicated_class.class_eval %{
      def to_arel
        #{arel_class.name}.new(left, right)
      end
    }

  end
  
end