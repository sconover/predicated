require "predicated/predicate"
require "predicated/evaluate"
require "predicated/string_utils"

module Predicated
  module Shorthand
    def method_missing(uppercase_cameled_method_sym, *args)
      subject = args.shift
      method_sym = StringUtils.underscore(uppercase_cameled_method_sym.to_s).to_sym
      object = args
      Call(subject, method_sym, *(object.empty? ? [] : object))
    end
  end

  module SimpleTemplatedShorthand
    def method_missing(uppercase_cameled_method_sym, *args)
      method_sym = StringUtils.underscore(uppercase_cameled_method_sym.to_s).to_sym
      object = args
      Call(method_sym, *(object.empty? ? [] : object))
    end
  end
end