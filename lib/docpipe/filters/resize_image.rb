require 'docpipe/commands/graphics_magick'

module Docpipe
  class ResizeImage
    def initialize(next_filter, inner_pipeline, options)
      @next_filter = next_filter
      @resizer = options[:resizer] || GraphicsMagick.new
      @height = options[:height]
    end

    def call(env)
      @resizer.resize(env[:document_path], @height)
      @next_filter.call(env)
    end
  end
end
