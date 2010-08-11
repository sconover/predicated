
class Object
  def singleton_class
     class << self
       self
     end
  end
end

module Predicated
  module Selectable
    #this is no doubt totally non-performant with all the extends, and 
    #could probably be just done better / more elegantly
    #seek help.

    def self.bless_enumerable(enumerable, selectors)
      enumerable.singleton_class.instance_eval do
        include Selectable
        selector selectors
      end
    end

    SELECTORS_INSTANCE_VARIABLE_NAME = :@selectors

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def selector(hash)
        sym = SELECTORS_INSTANCE_VARIABLE_NAME
        existing = instance_variable_get(sym) || {}
        instance_variable_set(sym, existing.merge(hash))
      end
    end

    def selectors
      sym = SELECTORS_INSTANCE_VARIABLE_NAME
      class_selectors = self.class.instance_variable_get(sym) || {}
      singleton_selectors = self.singleton_class.instance_variable_get(sym) || {}
      instance_selectors = self.instance_variable_get(sym) || {}
      class_selectors.merge(singleton_selectors).merge(instance_selectors)
    end

    def select(*keys, &block)
      if block_given?
        super
      else
        key = keys.shift
        result =
          if key
            selecting_proc = selectors[key]
            raise "no selector found for '#{key}'.  current selectors: [#{selectors.collect { |k, v| k.to_s }.join(",")}]" unless selecting_proc
            memos_for(:select)[key] ||= begin
              super(&selecting_proc)
            end
          else
            raise "select must be called with either a key or a block"
          end

        Selectable.bless_enumerable(result, selectors)
        if keys.length >= 1
          result.select(*keys, &block)
        else
          result
        end
      end
    end

    private
    def memos_for(group)
      @memos ||= {}
      @memos[group] ||= {}
    end
  end

end
