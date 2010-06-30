require "predicated/from/url_fragment_parser"

module Predicated
  module From
    class UrlFragment
      def convert(url_fragment_string)
        TreetopUrlFragmentParser.new.parse(url_fragment_string).to_predicate
      end
    end
  end
end