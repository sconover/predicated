require "predicated/from/url_fragment_parser"

module Predicated
  module Predicate
    def self.from_url_fragment(url_fragment_string)
      TreetopUrlFragmentParser.new.parse(url_fragment_string).to_predicate
    end
  end
end