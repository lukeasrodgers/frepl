module Frepl
  class DerivedType < MultilineStatement
    def terminal_regex
      /end type/
    end

    def accept(visitor)
      visitor.visit_derived_type(self)
    end

    def name
      @name ||= lines.first.match(Frepl::Classifier::DERIVED_TYPE_REGEX)[1]
    end

    def ==(other)
      if other.is_a?(DerivedType)
        self.name == other.name
      else
        super(other)
      end
    end
  end
end
