module Frepl
  class ReplCommand < SinglelineStatement
    COMMANDS = {
      'run' => {
        info: 'Run the current set of Fortran code',
        l: lambda { |file| file.run },
      },
      'toggle_debug' => {
        info: 'Toggle debug mode on/off',
        l: lambda { |file| Frepl.debug = !Frepl.debug },
      },
      'help' => {
        info: 'View this hopefully helpful help',
        l: lambda do |file|
          puts "Available Frepl commands:\n"
          COMMANDS.each do |k, v|
            puts "f:#{k} -- #{v[:info]}"
          end
        end
      },
      'z' => {
        info: 'Undo last statement',
        l: lambda do |file|
          file.undo_last!
        end
      }
    }

    def accept(visitor)
      visitor.visit_repl_command(self)
    end

    def run(file)
      Frepl.log("running: #{cmd}")
      if COMMANDS.key?(cmd)
        COMMANDS[cmd][:l].call(file)
      else
        puts "Unknown command: `#{cmd}`. Type `f:help` for list of commands."
      end
    end

    def cmd
      @cmd ||= line.match(/f:(.+)/)[1]
    end
  end
end
