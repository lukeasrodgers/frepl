module Frepl
  class Declaration < SinglelineStatement
    attr_reader :variable_name, :assigned_value, :type

    def accept(visitor)
      visitor.visit_declaration(self)
    end

    def ==(other)
      if other.is_a?(Declaration)
        self.variable_name == other.variable_name
      else
        super(other)
      end
    end

    private
    
    def parse
      match_data = line.match(Frepl::Classifier::DECLARATION_REGEX)
      variable_part = match_data[4]
      variable_data = variable_part.match(/\s*([^\s=])\s*+=*\s*(.*)?/)
      @variable_name = variable_data[1]
      @assigned_value = variable_data[2].empty? ? nil : variable_data[2]
      @type = match_data[1]
    end
  end
end
