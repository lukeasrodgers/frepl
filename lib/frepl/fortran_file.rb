module Frepl
  class FortranFile
    BEGIN_PROGRAM_STATEMENT = "program frepl_out\n"
    END_PROGRAM_STATEMENT = "end program frepl_out\n"
    FUNC_SUBROUTINE_HEADER = "  contains\n"
    IMPLICIT_STATEMENT = "  implicit none\n"

    def initialize
      @declarations = []
      @assignments = []
      @execution = nil
      @allocations = []
      @subroutines = []
      @functions = []
    end

    def run
      File.open('frepl_out.f90', 'w+') do |f|
        f << BEGIN_PROGRAM_STATEMENT
        f << IMPLICIT_STATEMENT

        @declarations.each do |d|
          f.write(d.output) end

        @allocations.each do |a|
          f.write(a.output)
        end

        @assignments.each do |a|
          f.write(a.output)
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
      puts o
    end

    def add(line_obj)
      line_obj.accept(self)
      Frepl.log("added")
      Frepl.log("declarations: #{@declarations}")
      Frepl.log("assignments: #{@assignments}")
    end

    def visit_declaration(d)
      @declarations << d
    end

    def visit_assignment(a)
      @assignments << a
      Frepl.log("assignment name: #{a.variable_name}")
    end

    def visit_allocation(a)
      @allocations << a
    end

    def visit_execution(e)
      @execution = e
      run
    end

    def visit_repl_command(cmd)
      cmd.run(self)
    end

    def visit_function(fn)
      @functions << fn
    end

    def visit_subroutine(sub)
      @subroutines << sub
    end
  end
end
