require 'rspec_editor'

module RspecEditor
  class Editor
    def check_enabled!
      unless editor_enabled?
        STDERR.puts "  #{self.class} set $RSPEC_EDITOR to enable."
      end
    end

    def editor_enabled?
      ! ! rspec_editor
    end

    def rspec_editor
      (@rspec_editor ||= [ ENV['RSPEC_EDITOR'] ]).first
    end

    def log_name
      @log_name = ENV['RSPEC_EDITOR_LOG'] || '.rspec.error.log'
    end

    def write_examples!
      @log_name = ".rspec.error.log"
      log_already_exists = File.exist?(@log_name)
      File.open("#{@log_name}.tmp", "w") do | fh |
        @log = fh
        @log.puts "-*- mode: grep; mode: auto-revert; default-directory: \"#{Dir.pwd}/\" -*-"
        @log.puts ""
        yield self
      end
      File.rename("#{@log_name}.tmp", @log_name)
      if log_already_exists
        $stderr.puts "  # Refresh #{@log_name} in your editor."
      else
        editor! @log_name
      end
    ensure
      @log = nil
    end

    def write_example! example
      location = example.location
      # location = File.expand_path(example.location)
      exc = example.execution_result[:exception]
      exc_desc = exc.inspect.gsub(/\n/, ' ')
      @log.puts "#{location}: # #{example.full_description}"
      @log.puts "#{location}: # #{exc_desc}"
      i = 0
      format_backtrace(exc.backtrace, example).each do |backtrace_info|
        # backtrace_info = File.expand_path(backtrace_info)
        @log.puts "#{backtrace_info}\t # #{i += 1}"
      end
    end

    def open_example! example
      example.location =~ /^([^:]+)(:(\d+))?$/
      file, line = $1, $3
      editor! file, line
    end

    def editor! file, line = nil
      cmd = editor_cmd(file, line)
      output.puts "  Using editor: #{cmd}"
      begin
        Process.fork do
          system(cmd)
        end
      rescue
        $stderr.puts "  #{self}: ERROR: #{cmd}: #{$!.inspect}"
      end
    end

    def editor_cmd file, line = nil
      file = File.expand_path(file)
      line = nil if line && line.empty?
      editor = rspec_editor
      case editor
      when /emacs/
        line &&= "+#{line}"
        unless File.exist?(editor)
          editor = emacsclient
        end
        cmd = "#{editor} -q -n #{line} #{file}"
      when /vi/
        line &&= "+#{line}"
        cmd = "#{editor} --remote #{line} #{file}"
      else
        line &&= "--line #{line}"
        cmd = "#{editor} #{line} #{file}"
      end
      cmd
    end

    def emacsclient
      @emacsclient ||=
      [
        '/Applications/Aquamacs.app/Contents/MacOS/bin/emacsclient',
        '/opt/local/bin/emacsclient',
        '/usr/bin/emacsclient',
      ].find{|f| File.executable? f} || 'emacsclient'
    end
  end
end

