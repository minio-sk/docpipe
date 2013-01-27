module Docpipe
  class ExtractImages
    def initialize(next_filter, inner_pipeline, options = {})
      @format = options[:format]
      @dpi = options[:dpi]
      @command = options[:command] || Docpipe::Command.new
      @next_filter = next_filter
      @inner_pipeline = inner_pipeline
    end

    def call(env)
      filename = File.basename(env[:document_path], File.extname(env[:document_path]))
      output_filename = "#{filename}-%00d.#{@format}"
      output_glob = "#{filename}-*.#{@format}"
      output_path = if env[:output_path]
                      File.join(env[:output_path], output_filename)
                    else
                      output_filename
                    end
      @command.run("gs -dNOPAUSE -dBATCH -sDEVICE=? -r? -sOutputFile=? ?", @format, @dpi, output_path, env[:document_path])
      Dir.glob(output_glob).each do |page|
        @inner_pipeline.run(page)
      end if @inner_pipeline
      @next_filter.call(env)
    rescue Docpipe::CommandFailed => e
      raise Docpipe::ExtractionFailed, e.message
    end
  end
end
