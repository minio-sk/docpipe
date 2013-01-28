require 'docpipe/commands/tesseract'

module Docpipe
  describe Tesseract do
    it 'runs the correct tesseract command, stripping extension from the output name' do
      command = mock(:Command)
      command.should_receive(:run).with('tesseract ? ? -l ?', 'document_1.jpeg', 'document_1', 'ces')
      tesseract = Tesseract.new(command)
      tesseract.extract('document_1.jpeg', 'document_1.txt', 'ces')
    end
  end
end
