require 'docpipe/pipeline'

module Docpipe
  describe Pipeline do
    NO_INNER_PIPELINE = nil

    let(:filter_class) { mock(:FilterClass) }
    let(:filter) { mock(:Filter) }
    let(:another_filter_class) { mock(:AnotherFilterClass) }
    let(:another_filter) { mock(:AnotherFilter) }
    let(:noop_filter) { mock(:NoopFilter) }

    subject(:pipeline) { Pipeline.new(noop: noop_filter) }

    it 'initializes each filter with next filter and its options' do
      another_filter_class.stub(new: another_filter)
      filter_class.should_receive(:new).with(another_filter, NO_INNER_PIPELINE, { size: 1000 })

      pipeline.use filter_class, size: 1000
      pipeline.use another_filter_class
      pipeline.build
    end

    it 'passes special noop filter to last filter in chain' do
      filter_class.should_receive(:new).with(noop_filter, NO_INNER_PIPELINE, { size: 1000 })
      pipeline.use filter_class, size: 1000
      pipeline.build
    end

    context 'when composing inner pipelines' do
      it 'constructs the outer filter with reference to the inner pipeline' do
        block = lambda {}
        inner_pipeline = stub
        block.stub(call: inner_pipeline)
        another_filter_class.stub(new: another_filter)
        filter_class.should_receive(:new).with(another_filter, inner_pipeline, {})

        pipeline.use filter_class, &block
        pipeline.use another_filter_class
        pipeline.build
      end
    end

    it 'runs the first filter in chain' do
      filter_class.stub(new: filter)
      filter.should_receive(:call).with(document_path: 'doc.pdf')
      pipeline.use filter_class, size: 1000
      pipeline.build
      pipeline.run('doc.pdf')
    end
  end
end
