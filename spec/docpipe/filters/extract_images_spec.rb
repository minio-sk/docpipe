require 'docpipe/filters/extract_images'

module Docpipe
  describe ExtractImages do
    let(:command) { mock(:Command).as_null_object }

    it 'runs the correct command to extract images' do
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, command: command)
      command.should_receive(:run).with("gs -dNOPAUSE -dBATCH -sDEVICE=? -r? -sOutputFile=? ?", 'gif', 200, 'document-%00d.gif', 'document.pdf')
      filter.call(document_path: 'document.pdf')
    end

    it 'runs the command with correct output path' do
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, command: command)
      command.should_receive(:run).with("gs -dNOPAUSE -dBATCH -sDEVICE=? -r? -sOutputFile=? ?", 'gif', 200, '/tmp/x/document-%00d.gif', 'document.pdf')
      filter.call(document_path: 'document.pdf', output_path: '/tmp/x')
    end

    it 'invokes the inner pipeline for each extracted page' do
      Dir.should_receive(:glob).with('document-*.gif').and_return(['document-1.gif'])
      inner_pipeline = mock(:InnerPipeline)
      inner_pipeline.should_receive(:run).with('document-1.gif')
      filter = ExtractImages.new(stub.as_null_object, inner_pipeline, format: 'gif', dpi: 200, command: command)
      filter.call(document_path: 'document.pdf')
    end

    it 'does not invoke inner pipeline if none was defined' do
      Dir.stub(glob: ['document-1.gif'])
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, command: command)
      filter.call(document_path: 'document.pdf')
    end

    it 'invokes next filter in chain' do
      next_filter = mock(:NextFilter)
      next_filter.should_receive(:call).with(document_path: 'document.pdf')
      filter = ExtractImages.new(next_filter, nil, command: command)
      filter.call(document_path: 'document.pdf')
    end

    it 'raises error if the command fails' do
      class Docpipe::CommandFailed < StandardError; end
      class Docpipe::ExtractionFailed < StandardError; end

      command.should_receive(:run).and_raise(Docpipe::CommandFailed)
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, command: command)
      expect { filter.call(document_path: 'document.pdf') }.to raise_error(Docpipe::ExtractionFailed)
    end
  end
end
