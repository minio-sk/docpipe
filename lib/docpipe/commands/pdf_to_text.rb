require 'docpipe/command'

module Docpipe
  class PdfToText
    def initialize(command = Command.new, validator = TextLengthValidator.new)
      @command = command
      @validator = validator
    end

    def extract(page_number, pdf_path, output_path)
      @command.run('pdftotext -enc UTF-8 -f ? -l ? ? ?', page_number, page_number, pdf_path, output_path)
      @validator.valid?(output_path)
    end

    class TextLengthValidator
      MIN_TEXT_PER_PAGE = 100

      def valid?(path)
        File.read(path).length > MIN_TEXT_PER_PAGE
      end
    end
  end
end
