require 'docpipe/filters/delete'

module Docpipe
  describe Delete do
    it 'deletes the document' do
      delete = Delete.new(stub.as_null_object, nil, {})
      FileUtils.should_receive(:rm).with('document.pdf')
      delete.call(document_path: 'document.pdf')
    end

    it 'invokes next filter in chain' do
      env = { document_path: 'document.jpg' }
      next_filter = mock(:NextFilter)
      filter = Delete.new(next_filter, nil, {})
      next_filter.should_receive(:call).with(env)
      FileUtils.stub(rm: nil)
      filter.call(env)
    end
  end
end
