require 'docpipe/filters/resize_image'

module Docpipe
  describe ResizeImage do
    let(:resizer) { mock(:Resizer) }

    it 'invokes the resizer command with correct arguments' do
      resizer.should_receive(:resize).with('document.jpg', 1000)
      filter = ResizeImage.new(stub.as_null_object, nil, height: 1000, resizer: resizer)
      filter.call(document_path: 'document.jpg')
    end

    it 'invokes next filter in chain' do
      env = { document_path: 'document.jpg' }
      next_filter = mock(:NextFilter)
      resizer.as_null_object
      filter = ResizeImage.new(next_filter, nil, height: 1000, resizer: resizer)
      next_filter.should_receive(:call).with(env)
      filter.call(env)
    end
  end
end
