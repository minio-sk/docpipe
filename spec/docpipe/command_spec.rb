require 'docpipe/command'

module Docpipe
  describe Command do
    class CommandFailed < StandardError; end

    subject(:command) { Command.new }

    it 'runs command without arguments' do
      Open3.should_receive(:popen2e).with('ls').and_return(0)
      command.run('ls')
    end

    it 'replaces all ? with the appropriate arguments' do
      Open3.should_receive(:popen2e).with('ls /tmp /dev').and_return(0)
      command.run('ls ? ?', "/tmp", "/dev")
    end

    it 'escapes the arguments' do
      Open3.should_receive(:popen2e).with('ls \"').and_return(0)
      command.run('ls ?', '"')
    end

    it 'raises exception if the command fails' do
      Open3.should_receive(:popen2e).and_return(1)
      expect { command.run('ls nodir') }.to raise_error(Docpipe::CommandFailed)
    end

    it 'coerces arguments to string' do
      Open3.should_receive(:popen2e).with('ls 200').and_return(0)
      command.run('ls ?', 200)
    end

  end
end
