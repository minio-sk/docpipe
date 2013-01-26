require 'docpipe'

describe Docpipe do
  let(:pipeline) { stub.as_null_object }

  it 'passes preinitialized env to the pipeline' do
    block = lambda{}
    block.should_receive(:call).with(pipeline)
    Docpipe.build(pipeline: pipeline, &block)
  end

  it 'returns the built pipeline' do
    pipeline.should_receive(:build)
    (Docpipe.build(pipeline: pipeline) {}).should == pipeline
  end
end
