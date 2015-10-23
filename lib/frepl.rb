require 'readline'
require 'frepl/version'
require 'frepl/classifier'
require 'frepl/statement'
require 'frepl/fortran_file'

module Frepl
  extend self

  attr_accessor :compiler, :debug

  def log(message)
    puts message if @debug
  end

  class Main
    class << self
      def run
        new.run
      end
    end

    def initialize
      Frepl.compiler = 'gfortran'
      Frepl.debug = false
      reset!
    end

    def run
      loop do
        begin
          while buf = Readline.readline(prompt, true)
            @lines << buf
            process_line(buf)
          end
        rescue Interrupt
          @classifier.interrupt
          puts "^C\n"
        rescue SystemExit, SignalException
          raise
        rescue Exception => e
          puts "Exception!: #{e}"
          puts e.backtrace
          raise
        end
      end
    end
    
    def run_file(file)
      file.each do |line|
        @lines << line
        process_line(line)
      end
      reset!
    end

    private

    def prompt
       '> ' + (' ' * @classifier.indentation_level)
    end

    def process_line(line)
      exit(0) if line.chomp == 'q'
      Frepl.log("classifying: #{line}")
      line_obj = @classifier.classify(line)
      @file.add(line_obj) unless line_obj.nil? || line_obj.incomplete?
    end

    def reset!
      @classifier = Classifier.new
      @file = FortranFile.new
      @lines = []
    end
  end

end
