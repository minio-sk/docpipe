require 'docpipe/pipeline'

module Docpipe
  describe Pipeline do
    NO_INNER_PIPELINE = nil

    let(:filter_class) { mock(:FilterClass) }
    let(:filter) { mock(:Filter) }
    let(:another_filter_class) { mock(:AnotherFilterClass) }
    let(:another_filter) { mock(:AnotherFilter) }
    let(:noop_filter) { mock(:NoopFilter) }
    let(:inner_pipeline) { mock(:InnerPipeline) }
    let(:inner_pipeline_builder) { stub(:PipelineBuilder, build: inner_pipeline) }

    subject(:pipeline) { Pipeline.new(noop: noop_filter, inner_pipeline_builder: inner_pipeline_builder) }

    it 'initializes each filter with next filter, empty inner pipeline and its options' do
      another_filter_class.stub(new: another_filter)
      filter_class.should_receive(:new).with(another_filter, inner_pipeline, { size: 1000 })

      pipeline.use filter_class, size: 1000
      pipeline.use another_filter_class
      pipeline.build
    end

    it 'passes special noop filter to last filter in chain' do
      filter_class.should_receive(:new).with(noop_filter, inner_pipeline, { size: 1000 })
      pipeline.use filter_class, size: 1000
      pipeline.build
    end

    context 'when composing inner pipelines' do
      it 'yields a fresh pipeline to the inner pipeline defining block' do
        filter_class.as_null_object
        pipeline = Pipeline.new(noop: noop_filter, inner_pipeline_builder: inner_pipeline_builder)
        block = lambda {}
        inner_pipeline_builder.should_receive(:build).with(&block)

        pipeline.use filter_class, &block
        pipeline.build
      end
    end

    it 'runs the first filter in chain' do
      filter_class.stub(new: filter)
      filter.should_receive(:call).with(document_path: 'doc.pdf', output_path: 'out/x')
      pipeline.use filter_class, size: 1000
      pipeline.build
      pipeline.run(document_path: 'doc.pdf', output_path: 'out/x')
    end
  end
end
