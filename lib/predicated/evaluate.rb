module Predicated
  class Operation
    def evaluate(context=binding())
      code = "#{left} #{sign} #{right}"
      eval(code, context)
    end
  end
  
  class Equal < Operation; private; def sign; "==" end end
  class LessThan < Operation; private; def sign; "<" end end
  class GreaterThan < Operation; private; def sign; ">" end end
  class LessThanOrEqualTo < Operation; private; def sign; "<=" end end
  class GreaterThanOrEqualTo < Operation; private; def sign; ">=" end end
end