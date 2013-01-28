require 'docpipe/filters/extract_text'

module Docpipe
  describe ExtractText do
    let(:dte) { mock(:DirectTextExtractor) }
    let(:ocr) { mock(:OCR) }

    context 'when the page contains embedded text' do
      it 'calls pdftotext to extract text from this particular page' do
        dte.should_receive(:extract).with(2, 'document.pdf', './document_1.txt').and_return(true)
        filter = ExtractText.new(stub.as_null_object, nil, language: 'ces', direct_text_extractor: dte)
        filter.call(document_path: 'document_1.jpeg', parent_document_path: 'document.pdf', page_number: 2, output_path: '.')
      end

      it 'evaluates output lambda to calculate output path' do
        dte.should_receive(:extract).with(2, 'document.pdf', './pages/document_1.txt').and_return(true)
        filter = ExtractText.new(stub.as_null_object, nil, language: 'ces', direct_text_extractor: dte, output: lambda { |d| "pages/#{d}" })
        filter.call(document_path: 'document_1.jpeg', parent_document_path: 'document.pdf', page_number: 2, output_path: '.')
      end

      it 'attempts OCR if direct text extraction fails' do
        dte.stub(extract: false)
        ocr.should_receive(:extract).with('document_1.jpeg', './document_1.txt', 'ces')
        filter = ExtractText.new(stub.as_null_object, nil, language: 'ces', direct_text_extractor: dte, ocr: ocr)
        filter.call(document_path: 'document_1.jpeg', parent_document_path: 'document.pdf', page_number: 2, output_path: '.')
      end

      it 'calls the next filter in chain and passes the env' do
        dte.as_null_object
        env = {document_path: 'document_1.jpeg', parent_document_path: 'document.pdf', page_number: 2, output_path: '.'}
        next_filter = mock(:NextFilter)
        next_filter.should_receive(:call).with(env)
        filter = ExtractText.new(next_filter, nil, language: 'ces', direct_text_extractor: dte, output: lambda { |d| "pages/#{d}" })
        filter.call(env)
      end
    end
  end
end
