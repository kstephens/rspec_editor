require "rspec/core/formatters/base_formatter"

module RspecEditor
module Rspec2
  class Formatter < RSpec::Core::Formatters::BaseFormatter
    def initialize *args, &blk
      @editor = Editor.new
      @editor.check_enabled!
      super
    end

    def start_dump
      result = super
      if editor.enabled?
        begin
          editor.open
          process_examples!
          result
        ensure
          editor.close
        end
      end
      result
    end

    private

    attr_reader :editor

    def process_examples!
      failed_examples.each do | example |
        write_example! example, editor
      end
    end

    def write_example! example, editor
      location = example.location
      # location = File.expand_path(location)
      editor.puts "#{location}: # #{example.full_description}"

      exc = example.execution_result[:exception]
      exc_desc = exc.inspect.gsub(/\n/, ' ')
      editor.puts "#{location}: # #{exc_desc}"

      i = 0
      format_backtrace(exc.backtrace, example).each do |backtrace_info|
        # backtrace_info = File.expand_path(backtrace_info)
        editor.puts "%70s # %d" % [ backtrace_info.to_s, i += 1 ]
      end

      editor.puts ""
    end
  end
end
end
