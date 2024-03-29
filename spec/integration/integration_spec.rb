require 'docpipe'

describe Docpipe do
  it 'runs complex pipeline' do
    pipeline = Docpipe.build do |pipeline|
      pipeline.use Docpipe::ExtractImages, dpi: 200, format: 'jpeg', output: lambda { |document_name| "1000x/#{document_name}_%00d.jpg" } do |pipeline|
        pipeline.use Docpipe::ExtractText, language: 'ces', output: lambda { |document_name| "pages/#{document_name}.txt" }
        pipeline.use Docpipe::ResizeImage, height: 1000
      end
    end
    pipeline.run(document_path: 'spec/integration/fixtures/document.pdf', output_path: 'spec/integration/fixtures')
  end

  # it 'creates pipeline and processes document' do
  #   pipeline = Docpipe::Pipeline.new do |pipeline|
  #     pipeline.use Docpipe::ExtractImages, size: 5000, format: 'gif' do |pipeline|
  #       pipeline.use Docpipe::ExtractText, language: 'ces'
  #       pipeline.use Docpipe::ResizeImage, size: 1000
  #     end
  #     pipeline.use Docpipe::DeleteOriginal
  #   end
  #   pipeline.run('document.pdf')
  # end
end
