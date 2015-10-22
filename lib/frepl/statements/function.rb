module Frepl
  class Function < MultilineStatement
    def terminal_regex
      /end function/
    end

    def accept(visitor)
      visitor.visit_function(self)
    end
  end
end
