require 'docpipe/command'

module Docpipe
  class Ghostscript
    def initialize(command = Command.new, collector = GlobbingCollector.new)
      @command = command
      @collector = collector
    end

    def convert(pdf_path, output_path, format, dpi)
      @command.run("gs -dNOPAUSE -dBATCH -sDEVICE=? -r? -sOutputFile=? ?", format, dpi, output_path, pdf_path)
      @collector.collect(output_path)
    end

    class GlobbingCollector
      def collect(output_path)
        glob_pattern = output_path.gsub(/%\d*?d/, '*')
        page_number_re = output_path.gsub(/%\d*?d/, '(\d+)')
        Dir.glob(glob_pattern).collect { |page_path| [page_path.match(page_number_re)[1], page_path] }
      end
    end
  end
end
