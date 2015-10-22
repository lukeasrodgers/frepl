module Frepl
  class Declaration < SinglelineStatement
    def accept(visitor)
      visitor.visit_declaration(self)
    end
  end
end
