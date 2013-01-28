require 'docpipe/command'
require 'docpipe/base_name'

module Docpipe
  class Tesseract
    def initialize(command = Command.new)
      @command = command
    end

    def extract(image_path, output_path, language)
      output_path = BaseName.strip_suffix(output_path)
      @command.run('tesseract ? ? -l ?', image_path, output_path, language)
    end
  end
end
