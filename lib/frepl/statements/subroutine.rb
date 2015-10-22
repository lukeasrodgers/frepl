module Frepl
  class Subroutine
    def terminal_regex
      /end subroutine/
    end

    def accept(visitor)
      visitor.visit_subroutine(self)
    end
  end
end
