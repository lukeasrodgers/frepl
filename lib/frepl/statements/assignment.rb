module Frepl
  class Assignment < SinglelineStatement
    def variable_name
      @variable_name ||= @line.match(Frepl::Classifier::ASSIGNMENT_REGEX)[1]
    end

    def assigned_value
      @assigned_value ||= @line.match(Frepl::Classifier::ASSIGNMENT_REGEX)[2]
    end

    def expressionize
      "write(*,*) #{variable_name}"
    end

    def accept(visitor)
      visitor.visit_assignment(self)
    end
  end
end
