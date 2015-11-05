module Frepl
  class DoLoop < MultilineStatement
    def terminal_regex
      /end do/
    end

    def accept(visitor)
      visitor.visit_do_loop(self)
    end

    private

    def starting_regex
      Frepl::Classifier::DO_LOOP_REGEX
    end
  end
end
