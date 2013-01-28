module Docpipe
  class BaseName
    def self.strip_suffix(path)
      path.gsub(/(.*)\.(.+?)$/, '\1')
    end

    def self.filename(path)
      strip_suffix(File.basename(path))
    end
  end
end
