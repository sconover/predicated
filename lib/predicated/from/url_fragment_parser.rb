require "treetop"
require "predicated/predicate"

module Predicated
  module From
    module TreetopUrlFragment
      Treetop.load_from_string(%{

grammar TreetopUrlFragment

  include Predicated::From::TreetopUrlFragment
  
  rule operation
    unquoted_string sign unquoted_string <Operation>
  end

  rule unquoted_string
    [0-9a-zA-Z]*
  end

  rule sign
	  ('>=' / '<=' / '<' / '>' / '=' )
  end
end

})
    
      class Operation < Treetop::Runtime::SyntaxNode
        def left_text; elements[0].text_value end
        def sign_text; elements[1].text_value end
        def right_text; elements[2].text_value end      
        
        SIGN_TO_PREDICATE_CLASS = {
          "=" => Equal, 
          ">" => GreaterThan,
          "<" => LessThan,
          ">=" => GreaterThanOrEqualTo,
          "<=" => LessThanOrEqualTo
        }
        
        def to_predicate
          SIGN_TO_PREDICATE_CLASS[sign_text].new(left_text, right_text)
        end
      end
    end
  end
end