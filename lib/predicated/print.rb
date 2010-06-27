module Predicated
  class Binary
    def to_s
      "#{self.class.shorthand}(#{part_to_s(left)},#{part_to_s(right)})"
    end
    
    private
    def part_to_s(thing)
      if thing.is_a?(String)
        "'#{thing}'"
      elsif thing.is_a?(Numeric) || thing.is_a?(TrueClass) || thing.is_a?(FalseClass) || thing.is_a?(Binary)
        thing.to_s
      else
        "#{thing.class.name}{'#{thing.to_s}'}"
      end
    end
  end
end