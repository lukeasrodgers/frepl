module Frepl
  class StandaloneVariable < SinglelineStatement
    def variable_name
      @variable_name ||= @line.match(Frepl::Classifier::VARIABLE_NAME_REGEX).to_s
    end

    def accept(visitor)
      visitor.visit_standalone_variable(self)
    end

    def expressionize
      "write(*,*) #{variable_name}"
    end
  end
end
