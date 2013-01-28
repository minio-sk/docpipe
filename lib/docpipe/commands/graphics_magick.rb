require 'docpipe/command'

module Docpipe
  class GraphicsMagick
    def initialize(command = Command.new)
      @command = command
    end

    def resize(image_path, height)
      @command.run("gm mogrify -resize ? ?", height, image_path)
    end
  end
end
