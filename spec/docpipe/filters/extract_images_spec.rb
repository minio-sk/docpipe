require 'docpipe/filters/extract_images'

module Docpipe
  describe ExtractImages do
    let(:pdf_to_images) { mock(:PdfToImages) }

    it 'calls pdf_to_images command to extract pages' do
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, pdf_to_images: pdf_to_images)
      pdf_to_images.should_receive(:convert).with('document.pdf', './document_%00d.gif', 'gif', 200).and_return([])
      filter.call(document_path: 'document.pdf', output_path: '.')
    end

    it 'evaluates output lambda to build output path' do
      filter = ExtractImages.new(stub.as_null_object, nil, format: 'gif', dpi: 200, output: lambda { |document_name| "%00d_#{document_name}.jpg" }, pdf_to_images: pdf_to_images)
      pdf_to_images.should_receive(:convert).with('document.pdf', '/tmp/%00d_document.jpg', 'gif', 200).and_return([])
      filter.call(document_path: 'document.pdf', output_path: '/tmp')
    end

    it 'invokes the inner pipeline for each extracted page with the correct env' do
      inner_pipeline = mock(:InnerPipeline)
      filter = ExtractImages.new(stub.as_null_object, inner_pipeline, format: 'gif', dpi: 200, output: lambda { |document_name| "%00d_#{document_name}.jpg" }, pdf_to_images: pdf_to_images)
      pdf_to_images.stub(:convert).and_return([[1, '/tmp/document_1.jpg']])
      inner_pipeline.should_receive(:run).with(document_path: '/tmp/document_1.jpg', parent_document_path: 'document.pdf', page_number: 1, output_path: '/tmp')
      filter.call(document_path: 'document.pdf', output_path: '/tmp')
    end

    it 'invokes next filter in chain' do
      env = { document_path: 'document.pdf', output_path: '/tmp' }
      next_filter = mock(:NextFilter)
      pdf_to_images.as_null_object
      filter = ExtractImages.new(next_filter, nil, format: 'gif', dpi: 200, pdf_to_images: pdf_to_images)
      next_filter.should_receive(:call).with(env)
      filter.call(env)
    end
  end
end
