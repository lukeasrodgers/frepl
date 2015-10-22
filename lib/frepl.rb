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
      Frepl.debug = true
      @classifier = Classifier.new
      @file = FortranFile.new
      @lines = []
    end

    def run
      while buf = Readline.readline('> ', true)
        @lines << buf
        process_line(buf)
      end
    end

    private

    def process_line(line)
      exit(0) if line.chomp == 'q'
      line_obj = @classifier.classify(line)
      @file.add(line_obj) unless line_obj.nil? || line_obj.incomplete?
    end
  end

end

Frepl::Main.run
