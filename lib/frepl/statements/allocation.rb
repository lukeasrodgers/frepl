require 'frepl/statements/declaration'

module Frepl
  class Allocation < Declaration
    def accept(visitor)
      visitor.visit_allocation(self)
    end
  end
end
