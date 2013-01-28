require 'docpipe/commands/ghostscript'

module Docpipe
  describe Ghostscript do
    let(:command) { mock(:Command) }
    let(:collector) { mock(:Collector) }

    it 'invokes ghostscript with correct commands' do
      collector.as_null_object
      command.should_receive(:run).with("gs -dNOPAUSE -dBATCH -sDEVICE=? -r? -sOutputFile=? ?", 'gif', 200, 'document_%00d.gif', 'document.pdf')
      gs = Ghostscript.new(command, collector)
      gs.convert('document.pdf', 'document_%00d.gif', 'gif', 200)
    end

    it 'returns the converted images with their numbers' do
      command.as_null_object
      pages = [[1, 'document_1.gif']]
      collector.should_receive(:collect).with('document_%00d.gif').and_return(pages)
      gs = Ghostscript.new(command, collector)
      gs.convert('document.pdf', 'document_%00d.gif', 'gif', 200).should == pages
    end
  end
end
