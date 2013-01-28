require 'docpipe/base_name'
require 'docpipe/commands/pdf_to_text'
require 'docpipe/commands/tesseract'

module Docpipe
  class ExtractText
    def initialize(next_filter, inner_pipeline, options)
      @next_filter = next_filter
      @dte = options[:direct_text_extractor] || PdfToText.new
      @ocr = options[:ocr] || Tesseract.new
      @output_lambda = options[:output] || lambda { |document_name| document_name }
      @language = options[:language]
    end

    def call(env)
      output_path = File.join(env[:output_path], @output_lambda.call(BaseName.filename(env[:document_path]) + ".txt"))
      FileUtils.mkdir_p(File.dirname(output_path)) unless File.exist?(File.dirname(output_path))
      unless @dte.extract(env[:page_number], env[:parent_document_path], output_path)
        @ocr.extract(env[:document_path], output_path, @language)
      end
      @next_filter.call(env)
    end
  end
end
