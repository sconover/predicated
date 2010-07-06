require "predicated/predicate"

module Predicated
  
  class And
    def to_solr
      "(#{left.to_solr} AND #{right.to_solr})"
    end
  end
  
  class Or
    def to_solr
      "#{left.to_solr} OR #{right.to_solr}"
    end
  end
  
  class Equal
    def to_solr
      "#{left}:#{right}"
    end
  end
  
  
end