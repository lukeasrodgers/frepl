require 'active_support/core_ext/string'

module Frepl
  class FortranFile
    BEGIN_PROGRAM_STATEMENT = "program frepl_out\n"
    END_PROGRAM_STATEMENT = "end program frepl_out\n"
    FUNC_SUBROUTINE_HEADER = "  contains\n"
    IMPLICIT_STATEMENT = "  implicit none\n"

    def initialize
      @all_statements = []
      @declarations = []
      @derived_types = []
      @assignments = []
      @execution = nil
      @allocations = []
      @subroutines = []
      @functions = []
      @wheres = []
    end

    def run
      File.open('frepl_out.f90', 'w+') do |f|
        f << BEGIN_PROGRAM_STATEMENT
        f << IMPLICIT_STATEMENT

        @derived_types.each do |dt|
          f.write(dt.output)
        end

        @declarations.each do |d|
          f.write(d.output)
        end

        @allocations.each do |a|
          f.write(a.output)
        end

        @assignments.each do |a|
          f.write(a.output)
        end

        if @file_io
          f.write(@file_io.output)
        end

        if @execution
          f.write(@execution.output)
        end

        if @subroutines.any? || @functions.any?
          f << FUNC_SUBROUTINE_HEADER

          @subroutines.each do |sub|
            f.write(sub.output)
          end

          @functions.each do |fn|
            f.write(fn.output)
          end
        end

        f << END_PROGRAM_STATEMENT
      end
      o = `#{Frepl.compiler} frepl_out.f90 -o frepl_out && ./frepl_out`
      Frepl.output(o)
    end

    def add(line_obj)
      line_obj.accept(self)
      @all_statements << line_obj
      Frepl.log("added")
      Frepl.log("declarations: #{@declarations}")
      Frepl.log("assignments: #{@assignments}")
    end

    def undo_last!
      last_statement = @all_statements.last
      ivar = instance_variable_get("@#{last_statement.class.to_s.demodulize.underscore.pluralize}")
      ivar.pop
    end

    def visit_declaration(declaration)
      if i = @declarations.find_index { |d| d == declaration }
        @declarations[i] = declaration
        if j = @assignments.find_index { |a| a.variable_name == declaration.variable_name }
          @assignments.slice!(j)
        end
      else
        @declarations << declaration
      end
    end

    def visit_multi_declaration(multi_declaration)
      multi_declaration.declarations.each do |d|
        visit_declaration(d)
      end
    end

    def visit_assignment(a)
      @assignments << a
      e = Execution.new(a.expressionize)
      visit_execution(e)
      Frepl.log("assignment name: #{a.variable_name}")
    end

    def visit_standalone_variable(sv)
      e = Execution.new(sv.expressionize)
      visit_execution(e)
    end

    def visit_allocation(a)
      @allocations << a
    end

    def visit_execution(e)
      @execution = e
      run
    end

    def visit_file_io(io)
      @file_io = io
      run
    end

    def visit_repl_command(cmd)
      cmd.run(self)
    end

    def visit_function(fn)
      if i = @functions.find_index { |f| f == fn }
        @functions[i] = fn
      else
        @functions << fn
      end
    end

    def visit_subroutine(sub)
      if i = @subroutines.find_index { |s| s == sub }
        @subroutines[i] = sub
      else
        @subroutines << sub
      end
    end

    def visit_ifstatement(i)
      e = Execution.new(i.output)
      visit_execution(e)
    end

    def visit_do_loop(d)
      e = Execution.new(d.output)
      visit_execution(e)
    end

    def visit_where(w)
      @assignments << w
    end

    def visit_derived_type(dt)
      if i = @derived_types.find_index { |v| v == dt }
        @derived_types[i] = dt
      else
        @derived_types << dt
      end
    end
  end
end
