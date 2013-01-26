require 'docpipe'

describe Docpipe do
  it 'creates pipeline and processes document' do
    pipeline = Docpipe.build do |pipeline|
      pipeline.use Docpipe::NoopFilter
    end
    pipeline.run('document.pdf')
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
