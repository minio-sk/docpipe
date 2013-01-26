require "docpipe/version"
require "docpipe/pipeline"

require 'docpipe/filters/noop_filter'

module Docpipe
  def self.build(options = {}, &block)
    pipeline = options[:pipeline] || Docpipe::Pipeline.new
    block.call(pipeline)
    pipeline.build
    pipeline
  end
end
