module Frepl
  class Where < MultilineStatement
    def terminal_regex
      /end where/i
    end

    def accept(visitor)
      visitor.visit_where(self)
    end

    private

    def starting_regex
      Frepl::Classifier::WHERE_REGEX
    end
  end
end
