module Predicated
  class Binary
    def to_s
      "#{self.class.shorthand}(#{part_to_s(left)},#{part_to_s(right)})"
    end
    
    def inspect(indent="")
      indent + to_s
    end
    
    private
    def part_to_s(thing)
      part_to_str(thing) {|thing| thing.to_s}
    end
    
    def part_inspect(thing, indent="")
      part_to_str(thing, indent) {|thing| thing.inspect(indent)}
    end
    
    def part_to_str(thing, indent="")
      if thing.is_a?(String)
        "'#{thing}'"
      elsif thing.is_a?(Numeric) || thing.is_a?(TrueClass) || thing.is_a?(FalseClass)
        thing.to_s
      elsif thing.is_a?(Binary)
        yield(thing)
      else
        "#{thing.class.name}{'#{thing.to_s}'}"
      end
    end
  end
  
  module ContainerInspect
    def inspect(indent="")
      next_indent = indent + " " + " "
      
      inspect_str = "#{indent}#{self.class.shorthand}(\n"
      inspect_str << "#{part_inspect(left, next_indent)},\n"
      inspect_str << "#{part_inspect(right, next_indent)}\n"
      inspect_str << "#{indent})"
      inspect_str << "\n" if indent == ""
      
      inspect_str
    end
  end
  
  class And; include ContainerInspect end
  class Or; include ContainerInspect end
  
end