module Frepl
  class Classifier
    def initialize
      @all_lines = []
      @current_lines = []
      @current_multiline_obj = nil
    end

    def classify(line)
      @all_lines << line
      @current_lines << line

      if @current_multiline_obj && !@current_multiline_obj.incomplete?
        @current_multiline_obj = nil
      end

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

    def declaration?
      current_line.match(/real|integer|type.*::\s+/) != nil
    end

    def allocation?
      current_line.match(/allocate\(/) != nil
    end

    def run?
      current_line.match(/\s*write|print|read|call/i) != nil
    end

    def assignment?
      # TODO var name regex
      current_line.match(/\s*[a-zA-Z0-9]+\s*=.*/) != nil
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
        # new obj
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
      current_line.match(/\A\s*\n\z/)
    end

    def comment?
      current_line.match(/\A!/)
    end
  end
end
