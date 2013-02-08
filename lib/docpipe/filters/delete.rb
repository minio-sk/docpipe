module Docpipe
  class Delete
    def initialize(next_filter, inner_pipeline, options)
      @next_filter = next_filter
    end

    def call(env)
      FileUtils.rm(env[:document_path])
      @next_filter.call(env)
    end
  end
end
