module Predicated
  module Selector  
    #this is no doubt totally non-performant with all the extends, and 
    #could probably be just done better / more elegantly
    #seek help.
    
    def self.SelectorEnumerable(key_to_selecting_proc)
      Module.new do
        @key_to_selecting_proc = key_to_selecting_proc
      
        def self.extended(base)
          sym = "@key_to_selecting_proc".to_sym
          hash = base.instance_variable_get(sym) || {}
          base.instance_variable_set(sym, hash.merge(@key_to_selecting_proc))
        end
      
        def self.included(base)
          extended(base)
        end    
        
        #ugh ugh
        def key_to_selecting_proc
          @key_to_selecting_proc || self.class.instance_variable_get("@key_to_selecting_proc".to_sym)
        end
        
        def select(*keys, &block)
          key = keys.shift if keys.length>=1
          result = 
            if key
              selecting_proc = key_to_selecting_proc[key]
              raise "no selector found for '#{key}'.  current selectors: [#{key_to_selecting_proc.collect{|k,v|k.to_s}.join(",")}]" unless selecting_proc
              memos_for(:select)[key] ||= super(&selecting_proc)
            else
              super(&block)
            end
          #ugh
          result.extend(Predicated::Selector.SelectorEnumerable(key_to_selecting_proc))
          keys.length>=1 ? result.select(*keys, &block) : result
        end
    
        private
        def memos_for(group)
          @memos ||= {}
          @memos[group] ||= {}
        end
      end
    end
    
    #ugh
    def SelectorEnumerable(key_to_selecting_proc)
      Predicated::Selector.SelectorEnumerable(key_to_selecting_proc)
    end

  end  
end