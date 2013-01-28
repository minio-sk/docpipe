require 'docpipe/commands/pdf_to_text'

module Docpipe
  describe PdfToText do
    it 'calls the correct command' do
      command = mock(:Command)
      command.should_receive(:run).with('pdftotext -enc UTF-8 -f ? -l ? ? ?', 2, 2, 'document.pdf', 'document_2.txt')
      pdftotext = PdfToText.new(command, stub(valid?: true))
      pdftotext.extract(2, 'document.pdf', 'document_2.txt')
    end

    it 'returns true if the extraction succeeds' do
      validator = mock(:Validator)
      validator.should_receive(:valid?).with('document_2.txt').and_return(true)
      pdftotext = PdfToText.new(stub.as_null_object, validator)
      pdftotext.extract(2, 'document.pdf', 'document_2.txt').should == true
    end

    it 'returns false if the extraction fails' do
      validator = mock(:Validator)
      validator.should_receive(:valid?).with('document_2.txt').and_return(false)
      pdftotext = PdfToText.new(stub.as_null_object, validator)
      pdftotext.extract(2, 'document.pdf', 'document_2.txt').should == false
    end
  end
end
