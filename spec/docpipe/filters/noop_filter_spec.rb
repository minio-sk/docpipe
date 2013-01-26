require 'docpipe/filters/noop_filter'

module Docpipe
  describe NoopFilter do
    it 'does nothing' do
      filter = NoopFilter.new
    end

  end
end
