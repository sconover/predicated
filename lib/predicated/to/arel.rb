require "arel"
require "predicated/predicate"

module Predicated
  
  {And => Arel::And,
   Or => Arel::Or}.each do |predicated_class, arel_class|

     predicated_class.class_eval %{
      def to_arel
        #{arel_class.name}.new(left.to_arel, right.to_arel)
      end
    }
     

  end
  
  {Equal => Arel::Equality,
   GreaterThan => Arel::GreaterThan,
   LessThan => Arel::LessThan,
   GreaterThanOrEqualTo => Arel::GreaterThanOrEqualTo,
   LessThanOrEqualTo => Arel::LessThanOrEqualTo}.each do |predicated_class, arel_class|

    predicated_class.class_eval %{
      def to_arel
        #{arel_class.name}.new(left, right)
      end
    }

  end
  
end