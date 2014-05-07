module TrelloLeadTime
  module ArraySearcher
    def find_name_like(elements, name)
      elements.detect { |element| element_matches_expression?(element, name) }
    end

    def element_matches_expression?(element, expression)
      element =~ /#{Regexp.quote(expression)}/
    end
  end
end
