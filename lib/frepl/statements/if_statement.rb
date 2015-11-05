module Frepl
  class IfStatement < MultilineStatement
    def terminal_regex
      /end\s?if/
    end

    def accept(visitor)
      visitor.visit_ifstatement(self)
    end

    private

    def starting_regex
      Frepl::Classifier::IF_STATEMENT_REGEX
    end
  end
end
