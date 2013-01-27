module Docpipe
  class Pipeline
    def initialize(options = {})
      @noop = options[:noop] || NoopFilter.new
      @filter_definition_chain = []
      @filter_chain = []
    end

    def use(filter_class, options = {}, &block)
      @filter_definition_chain << FilterConfiguration.new(filter_class, options, &block)
    end

    def build
      @last_filter = @noop
      begin
        filter_configuration = @filter_definition_chain.pop
        @last_filter = filter_configuration.build(@last_filter)
        @filter_chain << @last_filter
      end while not @filter_definition_chain.empty?
    end

    def run(path, env = {})
      @filter_chain.first.call(env.merge(document_path: path))
    end

    class FilterConfiguration
      attr_accessor :filter, :options, :block
      def initialize(filter, options, &inner_pipeline_definer)
        @filter = filter
        @options = options
        @inner_pipeline_definer = inner_pipeline_definer || lambda { nil }
      end

      def build(next_filter)
        filter.new(next_filter, @inner_pipeline_definer.call, @options)
      end
    end
  end
end
