require "docpipe/version"
require "docpipe/pipeline"
require 'docpipe/command'

require 'docpipe/filters/noop_filter'
require 'docpipe/filters/extract_images'
require 'docpipe/filters/extract_text'

module Docpipe
  class CommandFailed < StandardError; end
  class ExtractionFailed < StandardError; end

  def self.build(options = {}, &block)
    pipeline = options[:pipeline] || Docpipe::Pipeline.new
    block.call(pipeline)
    pipeline.build
    pipeline
  end
end
