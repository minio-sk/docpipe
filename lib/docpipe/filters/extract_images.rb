require 'docpipe/commands/ghostscript'
require 'docpipe/base_name'
require 'fileutils'

module Docpipe
  class ExtractImages
    def initialize(next_filter, inner_pipeline, options = {})
      @pdf_to_images = options[:pdf_to_images] || Ghostscript.new
      @format = options[:format]
      @dpi = options[:dpi]
      @output_lambda = options[:output] || lambda { |document_name| "#{document_name}_%00d.#{@format}" }
      @next_filter = next_filter
      @inner_pipeline = inner_pipeline
    end

    def call(env)
      output_path = File.join(env[:output_path], @output_lambda.call(BaseName.filename(env[:document_path])))
      FileUtils.mkdir_p(File.dirname(output_path)) unless File.exist?(File.dirname(output_path))
      pages = @pdf_to_images.convert(env[:document_path], output_path, @format, @dpi)
      pages.each do |page_number, page_path|
        @inner_pipeline.run(env.merge(document_path: page_path, page_number: page_number, parent_document_path: env[:document_path]))
      end
      @next_filter.call(env)
    end
  end
end
