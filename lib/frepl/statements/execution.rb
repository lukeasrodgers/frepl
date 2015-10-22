module Frepl
  class Execution < SinglelineStatement
    def accept(visitor)
      visitor.visit_execution(self)
    end
  end
end
