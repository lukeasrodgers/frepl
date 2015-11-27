module Frepl
  class FileIO < MultilineStatement
    def terminal_regex
      /close\(\d+\)/i
    end

    def accept(visitor)
      visitor.visit_file_io(self)
    end

    private

    def starting_regex
      Frepl::Classifier::FILE_IO_REGEX
    end
  end
end
