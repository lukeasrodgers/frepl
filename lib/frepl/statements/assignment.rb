module Frepl
  class Assignment < SinglelineStatement
    def variable_name
      @line.match(/^\s*([a-zA-Z0-9]+)/)[1]
    end

    def accept(visitor)
      visitor.visit_assignment(self)
    end
  end
end
