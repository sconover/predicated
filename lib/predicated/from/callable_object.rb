require "predicated/predicate"
require "predicated/from/ruby_string"

require 'ruby2ruby'
require 'parse_tree'

module Predicated
  module Predicate

                                  #you do what you have to I guess.
    def self.from_callable_object(context_or_callable_object=nil, context=nil, &block)
      callable_object = nil
      
      if context_or_callable_object.is_a?(Binding) || context_or_callable_object.nil?
        context = context_or_callable_object
        callable_object = block
      else
        callable_object = context_or_callable_object
      end
      
      context ||= callable_object.binding
      
      from_ruby_string(TranslateToRubyString.convert(callable_object), context)
    end

    module TranslateToRubyString
      #see http://stackoverflow.com/questions/199603/how-do-you-stringize-serialize-ruby-code
      def self.convert(callable_object)
        temp_class = Class.new
        temp_class.class_eval do
          define_method :serializable, &callable_object
        end
        ruby_string = Ruby2Ruby.translate(temp_class, :serializable)    
        ruby_string.sub(/^def serializable\n  /, "").sub(/\nend$/, "")
      end
    end
    
    #see http://gist.github.com/321038
    # # Monkey-patch to have Ruby2Ruby#translate with r2r >= 1.2.3, from
    # # http://seattlerb.rubyforge.org/svn/ruby2ruby/1.2.2/lib/ruby2ruby.rb
    class ::Ruby2Ruby < ::SexpProcessor
      def self.translate(klass_or_str, method = nil)
        sexp = ParseTree.translate(klass_or_str, method)
        unifier = Unifier.new
        unifier.processors.each do |p|
          p.unsupported.delete :cfunc # HACK
        end
        sexp = unifier.process(sexp)
        self.new.process(sexp)
      end
    end
    
  end
end