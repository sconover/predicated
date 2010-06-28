module Predicated
  
  #this is no doubt totally non-performant with all the extends, and 
  #could probably be just done better / more elegantly
  #seek help.
  def SelectorEnumerable(name_sym_to_selecting_proc)
    Module.new do
      @name_sym_to_selecting_proc = name_sym_to_selecting_proc
      
      def self.extended(base)
        base.instance_variable_set("@name_sym_to_selecting_proc".to_sym, @name_sym_to_selecting_proc)
      end
      
      def self.included(base)
        extended(base)
      end    
      
      def select(name_sym=nil, &block)
        result = 
          if name_sym
            selecting_proc = @name_sym_to_selecting_proc[name_sym]
            raise "no selector found for '#{name_sym}'" unless selecting_proc
            memos_for(:select)[name_sym] ||= super(&selecting_proc)
          else
            super(&block)
          end
        result.extend(SelectorEnumerable(@name_sym_to_selecting_proc))
        result
      end
    
      private
      def memos_for(group)
        @memos ||= {}
        @memos[group] ||= {}
      end

      
    end
  end  
end