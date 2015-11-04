module Frepl
  class Declaration < SinglelineStatement
    attr_reader :variable_name, :assigned_value, :type, :len, :kind

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
      variable_part = match_data[5]
      variable_data = variable_part.match(/\s*(#{Frepl::Classifier::VARIABLE_NAME_REGEX})\s*+=*\s*(.*)?/)
      @variable_name = variable_data[1]
      kind_len = match_data[2]
      if kind_len
        value = kind_len.match(/=?+([^=\(\)(?:kind|len)]+)/)[1]
        if kind_len.match(/kind/)
          @kind = value
        else
          @len = value
        end
      end
      @assigned_value = variable_data[2].empty? ? nil : variable_data[2]
      @type = match_data[1]
    end
  end
end
