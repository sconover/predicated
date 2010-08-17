require "predicated/predicate"
require "predicated/evaluate"
require "predicated/string_utils"

module Predicated
  class AutogenCall < Call
    def inspect
      method_cameled = StringUtils.uppercamelize(method_sym.to_s)
      
      if Predicated.const_defined?(:SimpleTemplatedShorthand) && left == Placeholder
        "#{method_cameled}#{self.send(:right_inspect)}"
      else
        left_str = self.send(:left_inspect)
        right_str = self.send(:right_inspect)
        right_str = "," + right_str unless right_str.empty?
        "#{method_cameled}(#{left_str}#{right_str})"
      end
    end
  end
  
  module Shorthand
    def method_missing(uppercase_cameled_method_sym, *args)
      subject = args.shift
      method_sym = StringUtils.underscore(uppercase_cameled_method_sym.to_s).to_sym
      object = args
      AutogenCall.new(subject, method_sym, *(object.empty? ? [] : object))
    end
  end

  module SimpleTemplatedShorthand
    def method_missing(uppercase_cameled_method_sym, *args)
      method_sym = StringUtils.underscore(uppercase_cameled_method_sym.to_s).to_sym
      object = args
      AutogenCall.new(Placeholder, method_sym, *(object.empty? ? [] : object))
    end
  end
end