module Frepl
  class Function < MultilineStatement
    def terminal_regex
      /end function/
    end

    def accept(visitor)
      visitor.visit_function(self)
    end

    def name
      @name ||= lines.first.match(Frepl::Classifier::FUNCTION_REGEX)[2]
    end

    def ==(other)
      if other.is_a?(Function)
        self.name == other.name
      else
        super(other)
      end
    end
    
    private

    def starting_regex
      Frepl::Classifier::FUNCTION_REGEX
    end
  end
end
