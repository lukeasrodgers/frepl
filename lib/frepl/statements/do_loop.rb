module Frepl
  class DoLoop < MultilineStatement
    def terminal_regex
      /\Aend do\z/
    end

    def accept(visitor)
      visitor.visit_do_loop(self)
    end
  end
end
