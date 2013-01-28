require 'docpipe/base_name'

module Docpipe
  describe BaseName do
    describe '#strip_suffix' do
      it 'strips suffix from the path' do
        BaseName.strip_suffix('dir/document_1.jpeg').should == 'dir/document_1'
      end

      it 'is not fooled by a dot in the path' do
        BaseName.strip_suffix('some.dir/document_1.jpeg').should == 'some.dir/document_1'
      end
    end

    describe '#filename' do
      it 'strips path prefix and suffix' do
        BaseName.filename('tmp/x/document_1.jpeg').should == 'document_1'
      end
    end
  end
end
