require 'docpipe/commands/graphics_magick'

module Docpipe
  describe GraphicsMagick do
    let(:command) { mock(:Command) }

    describe '#resize' do
      it 'calls the correct gm command' do
        gm = GraphicsMagick.new(command)
        command.should_receive(:run).with("gm mogrify -resize ? ?", 1000, 'document.jpg')
        gm.resize('document.jpg', 1000)
      end
    end
  end
end
