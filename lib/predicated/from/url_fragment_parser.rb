require "treetop"

module Predicated
  module UrlFragment
    Treetop.load_from_string(%{
grammar UrlFragment
  rule operation
    unquoted_string sign unquoted_string <Predicated::UrlFragment::Operation>
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
    end
    
  end
end