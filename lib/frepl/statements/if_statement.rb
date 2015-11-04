module Frepl
  class IfStatement < MultilineStatement
    def terminal_regex
      /\Aend\s?if\z/
    end

    def accept(visitor)
      visitor.visit_ifstatement(self)
    end
  end
end
