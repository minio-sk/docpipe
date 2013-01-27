require 'open3'
require 'shellwords'

module Docpipe
  class Command
    def run(command, *args)
      idx = 0
      escaped_command = command.gsub('?') do |match|
        Shellwords.escape(args[idx].to_s).tap do
          idx += 1
        end
      end
      exit_status, output = Open3.popen2e(escaped_command) do |stdin, stdout_stderr, wait_thr|
        [wait_thr.value.to_i, stdout_stderr.readlines.join]
      end

      raise CommandFailed, output if exit_status != 0
    end
  end
end
