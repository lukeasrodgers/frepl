module Frepl
  class Classifier
    VARIABLE_NAME_REGEX = /[a-zA-Z][a-zA-Z0-9_]{,30}/
    # TODO this regex seems incorrect, e.g. assignable value can't start with most punctuation
    ASSIGNABLE_VALUE_REGEX = /[^\s]+/
    DERIVED_TYPE_IDENTIFIER_REGEX = /\(#{VARIABLE_NAME_REGEX}\)/
    DERIVED_TYPE_REGEX = /type\s+(#{VARIABLE_NAME_REGEX})/i
    BUILTIN_TYPE_REGEX = /(?:double\s)?(?:real|integer|character|logical|complex)/i
    DECLARABLE_TYPE_REGEX = /#{BUILTIN_TYPE_REGEX}|type\s\(#{VARIABLE_NAME_REGEX}\)\s/i
    # TODO: parameter/dimension order shouldn't matter here
    DECLARATION_REGEX = /\As*(#{DECLARABLE_TYPE_REGEX})\s*(\((?:kind=|len=)*[^\(\)]+\)){,1}+(\s*,?\s*parameter\s*,?\s*)?(\s*,?\s*dimension\([^\)]+\))?(\s*,?\s*target)?(\s*,?\s*pointer)?\s*(?:::)?\s*([^(?:::)]*)/
    ASSIGNABLE_REGEX = /#{VARIABLE_NAME_REGEX}|#{VARIABLE_NAME_REGEX}%#{VARIABLE_NAME_REGEX}/
    ASSIGNMENT_REGEX = /\As*(#{ASSIGNABLE_REGEX})\s*=\s*(#{ASSIGNABLE_VALUE_REGEX})/
    OLDSKOOL_ARRAY_VALUE_REGEX = /\/[^\]]+\//
    F2003_ARRAY_VALUE_REGEX = /\[[^\]]+\]/
    ARRAY_VALUE_REGEX = /#{OLDSKOOL_ARRAY_VALUE_REGEX}|#{F2003_ARRAY_VALUE_REGEX}/
    FUNCTION_REGEX = /(#{BUILTIN_TYPE_REGEX})\s+function\s+(#{VARIABLE_NAME_REGEX})/i
    SUBROUTINE_REGEX = /subroutine\s+(#{VARIABLE_NAME_REGEX})/i
    IF_STATEMENT_REGEX = /if\s+\(.+\)\sthen/i
    DO_LOOP_REGEX = /do\s+[^,]+,.+/i
    WHERE_REGEX = /where\s+\([^\)]+\)\s*/i
    FILE_IO_REGEX = /open\(unit\s?=\s?\d+,\sfile\s?=\s?['"][^'"]+['"]\)/i

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
      @current_lines = []
    end

    def executable?
      !get_more_lines?
    end

    def lines_to_execute
      @current_lines
    end

    def multiline?(line)
      line.match(/\Asubroutine|function|(?:#{IF_STATEMENT_REGEX})|(?:#{DO_LOOP_REGEX})|(?:#{DERIVED_TYPE_REGEX})|(?:#{WHERE_REGEX})|(?:#{FILE_IO_REGEX})\z/i) || @current_multiline_obj != nil
    end

    def repl_command?
      current_line.start_with?('f:')
    end

    # TODO this is stupid, may need real parser here
    def multi_declaration?
      m = current_line.match(DECLARATION_REGEX)
      return false unless m
      if m[7].gsub(ARRAY_VALUE_REGEX, '').count(',') > 0
        true
      else
        false
      end
    end

    # TODO this is stupid, may need real parser here
    def declaration?
      m = current_line.match(DECLARATION_REGEX)
      return false unless m
      if m[7].gsub(ARRAY_VALUE_REGEX, '').count(',') == 0
        true
      else
        false
      end
    end

    def allocation?
      current_line.match(/allocate\(/) != nil
    end

    def input?
      current_line.match(/\s*open/i) != nil
    end

    def run?
      current_line.match(/\s*write|print|read|open|call/i) != nil
    end

    def assignment?
      current_line.match(ASSIGNMENT_REGEX)
    end

    def standalone_variable?
      current_line.match(/\A#{VARIABLE_NAME_REGEX}\z/)
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
        elsif line.match(IF_STATEMENT_REGEX)
          @current_multiline_obj = IfStatement.new
        elsif line.match(DO_LOOP_REGEX)
          @current_multiline_obj = DoLoop.new
        elsif line.match(/\A#{DERIVED_TYPE_REGEX}\z/)
          @current_multiline_obj = DerivedType.new
        elsif line.match(/\A#{WHERE_REGEX}\z/)
          @current_multiline_obj = Where.new
        elsif line.match(/\A#{FILE_IO_REGEX}\z/)
          @current_multiline_obj = FileIO.new
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
      elsif standalone_variable?
        StandaloneVariable.new(line)
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
