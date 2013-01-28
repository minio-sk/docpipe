require 'docpipe/filters/noop_filter'

module Docpipe
  class Pipeline
    def initialize(options = {})
      @noop = options[:noop] || NoopFilter.new
      @inner_pipeline_builder = options[:inner_pipeline_builder] || Docpipe
      @filter_definition_chain = []
      @filter_chain = []
    end

    def use(filter_class, options = {}, &block)
      @filter_definition_chain << FilterConfiguration.new(filter_class, options, block)
    end

    def build
      @last_filter = @noop
      while not @filter_definition_chain.empty?
        filter_configuration = @filter_definition_chain.pop
        @last_filter = filter_configuration.build(@last_filter, @inner_pipeline_builder)
      end
    end

    def run(env = {})
      @last_filter.call(env)
    end

    class FilterConfiguration
      attr_accessor :filter, :options, :block
      def initialize(filter, options, inner_pipeline_definer)
        @filter = filter
        @options = options
        @inner_pipeline_definer = inner_pipeline_definer || lambda { |p| }
      end

      def build(next_filter, pipeline_builder)
        filter.new(next_filter, pipeline_builder.build(&@inner_pipeline_definer), @options)
      end
    end
  end
end
