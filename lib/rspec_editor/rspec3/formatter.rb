require "rspec/core/formatters/base_text_formatter"

module RspecEditor
module Rspec3
  class Formatter < RSpec::Core::Formatters::BaseTextFormatter
    RSpec::Core::Formatters.register self, :open, :example_failed, :close

    def initialize *args
      super(nil)
      @editor = Editor.new
      @editor.check_enabled!
    end
    attr_reader :failed_examples

    def open *args
      if @editor.enabled?
        @editor.open
      end
    end

    def example_failed failure
      return unless @editor.enabled?
      @editor.open

      example = failure.example
      # location = File.expand_path(location)
      location = example.location
      editor.puts "#{location}: # #{example.full_description}"

      exc = example.execution_result.exception
      exc_desc = exc.inspect.gsub(/\n/, ' ')
      editor.puts "#{location}: # #{exc_desc}"

      i = 0
      exc.backtrace.each do | bt |
        bt = bt.to_s
        next if bt =~ %r{/lib/rspec/core/}
        break if bt =~ %r{/(?:bin|exe)/rspec:}
        # next if bt =~ %r{/bin/rspec:}
        # backtrace_info = File.expand_path(backtrace_info)
        editor.puts "%70s # %d" % [ bt, i += 1 ]
      end

      editor.puts ""
    end

    def close *args
      editor.close
    end

    private

    attr_reader :editor
  end
end
end
