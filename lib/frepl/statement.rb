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
      !complete?
    end

    def complete?
      @lines.last.match(terminal_regex) != nil && !nested?
    end

    def terminal_regex
      raise NotImplementedError
    end

    private

    def starting_regex
      raise NotImplementedError
    end

    def nested?
      start_count = lines.select { |line| line.match(/\A\s*#{starting_regex}\z/) != nil }.count
      end_count = lines.select { |line| line.match(/\A\s*#{terminal_regex}\z/) != nil }.count
      start_count > end_count
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
require 'frepl/statements/if_statement'
require 'frepl/statements/do_loop'
require 'frepl/statements/derived_type'
