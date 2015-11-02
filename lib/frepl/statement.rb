module Frepl
  class Statement
    def incomplete?
      raise NotImplementedError
    end

    def output
      raise NotImplementedError
    end

    def accept
      raise NotImplementedError
    end

    # def accept(visitor)
      # method = "visit_#{self.class.name.downcase}".to_sym
      # visitor.public_send(method, visitor)
    # end
  end

  class SinglelineStatement < Statement
    attr_reader :line

    def initialize(line)
      @line = line
      parse
    end

    def output
      @line.to_s + "\n"
    end
    
    def incomplete?
      false
    end

    private

    def parse
      # override me at your leisure, to get parsing on initialization
    end
  end

  class MultilineStatement < Statement
    attr_reader :lines

    def initialize(lines = [])
      @lines = lines
    end

    def output
      @lines.join("\n") + "\n"
    end

    def incomplete?
      !@lines.last.match(terminal_regex)
    end

    def terminal_regex
      raise NotImplementedError
    end
  end
end

require 'frepl/statements/function'
require 'frepl/statements/subroutine'
require 'frepl/statements/declaration'
require 'frepl/statements/multi_declaration'
require 'frepl/statements/allocation'
require 'frepl/statements/assignment'
require 'frepl/statements/standalone_variable'
require 'frepl/statements/execution'
require 'frepl/statements/repl_command'
