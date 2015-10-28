module Frepl
  class Classifier
    VARIABLE_NAME_REGEX = /[a-zA-Z][a-zA-Z0-9_]{,30}/
    ASSIGNABLE_VALUE_REGEX = /[^\s]+/
    TYPE_REGEX = /real|integer|character/
    # TODO: parameter/dimension order shouldn't matter here
    DECLARATION_REGEX = /\As*(#{TYPE_REGEX})\s*(\((?:kind|len)=\d+\)){,1}+(\s*,?\s*parameter\s*,\s*)?(\s*,?\s*dimension\([^\)]+\))?\s*(?:::)?\s*([^(?:::)]*)/
    ASSIGNMENT_REGEX = /\As*(#{VARIABLE_NAME_REGEX})\s*=\s*(#{ASSIGNABLE_VALUE_REGEX})/
    OLDSKOOL_ARRAY_VALUE_REGEX = /\/[^\]]+\//
    F2003_ARRAY_VALUE_REGEX = /\[[^\]]+\]/
    ARRAY_VALUE_REGEX = /#{OLDSKOOL_ARRAY_VALUE_REGEX}|#{F2003_ARRAY_VALUE_REGEX}/
    FUNCTION_REGEX = /(#{TYPE_REGEX})\s+function\s+(#{VARIABLE_NAME_REGEX})/
    SUBROUTINE_REGEX = /subroutine\s+(#{VARIABLE_NAME_REGEX})/

    def initialize
      @all_lines = []
      @current_lines = []
      @current_multiline_obj = nil
    end

    def classify(line)
      if @current_multiline_obj && !@current_multiline_obj.incomplete?
        @current_multiline_obj = nil
        @current_lines = []
      end

      @all_lines << line
      @current_lines << line

      if multiline?(line)
        Frepl.log("MULTILINE")
        classify_multiline(line)
        return @current_multiline_obj
      else
        return classify_single_line(line)
      end
    end

    def interrupt
      @current_multiline_obj = nil
    end

    def executable?
      !get_more_lines?
    end

    def lines_to_execute
      @current_lines
    end

    def multiline?(line)
      line.match(/subroutine|function/) || @current_multiline_obj != nil
    end

    def repl_command?
      current_line.start_with?('f:')
    end

    # TODO this is stupid, may need real parser here
    def multi_declaration?
      m = current_line.match(DECLARATION_REGEX)
      return false unless m
      if m[5].gsub(ARRAY_VALUE_REGEX, '').count(',') > 0
        true
      else
        false
      end
    end

    # TODO this is stupid, may need real parser here
    def declaration?
      m = current_line.match(DECLARATION_REGEX)
      return false unless m
      if m[5].gsub(ARRAY_VALUE_REGEX, '').count(',') == 0
        true
      else
        false
      end
    end

    def allocation?
      current_line.match(/allocate\(/) != nil
    end

    def run?
      current_line.match(/\s*write|print|read|call/i) != nil
    end

    def assignment?
      current_line.match(VARIABLE_NAME_REGEX)
    end

    def indentation_level
      if @current_multiline_obj && @current_multiline_obj.incomplete?
        2
      else
        0
      end
    end

    private

    def classify_multiline(line)
      if @current_lines.size == 1
        raise 'Already have multiline obj' unless @current_multiline_obj.nil?
        if line.match(/function/)
          @current_multiline_obj = Function.new
        elsif line.match(/subroutine/)
          @current_multiline_obj = Subroutine.new
        end
      end
      @current_multiline_obj.lines << line
    end

    def classify_single_line(line)
      obj = if repl_command?
        ReplCommand.new(line)
      elsif multi_declaration?
        MultiDeclaration.new(line)
      elsif declaration?
        Declaration.new(line)
      elsif run?
        Execution.new(line)
      elsif assignment?
        Assignment.new(line)
      elsif allocation?
        Allocation.new(line)
      elsif ignorable?
        nil
      else
        puts "I don't think `#{line}` is valid Fortran. You made a mistake, or, more likely, I'm dumb."
        @all_lines.pop
        obj = nil
      end
      @current_lines = []
      obj
    end

    def current_line
      @current_lines.last
    end

    def get_more_lines?
      @current_lines.size > 0 || @current_lines.last.match(/subroutine|function/)
    end

    def done_multiline?
      @current_lines.size > 0 && @current_lines.last.match(/end subroutine|end function/)
    end

    def ignorable?
      program_statements? || blank? || comment?
    end

    def program_statements?
      current_line.match(/\Aprogram .+|implicit .+|\Aend program/) != nil
    end

    def blank?
      current_line.match(/\A\s*\z/)
    end

    def comment?
      current_line.match(/\A!/)
    end
  end
end
