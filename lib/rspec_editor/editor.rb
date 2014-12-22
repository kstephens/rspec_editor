require 'rspec_editor'

module RspecEditor
  class Editor
    attr_accessor :editor, :output_file

    def check_enabled!
      unless enabled?
        log "set $RSPEC_EDITOR to enable."
      end
      self
    end

    def enabled?
      ! ! editor
    end

    def editor
      @editor ||= ENV['RSPEC_EDITOR']
    end

    def output_file
      @output_file ||= ENV['RSPEC_EDITOR_OUT'] || '.rspec.error.log'
    end

    def current_directory
      @current_directory ||= Dir.pwd
    end

    def open
      return if @out
      @log_already_exists = File.exist?(output_file)
      @out = File.open(@tmp_file = "#{output_file}.tmp", "w")
      puts "-*- mode: grep; mode: auto-revert; default-directory: \"#{current_directory}/\" -*-"
      puts ""
    end

    def close *args
      return self unless @out
      @out.close rescue nil
      @out = nil
      File.rename(@tmp_file, output_file)
      if @log_already_exists
        log "# Refresh #{output_file} in your editor."
      else
        editor! output_file
      end
      self
    ensure
      @out = @log_already_exists = nil
    end

    def puts msg
      @out.puts msg
    end

    def open_example! location
      if location.to_s =~ /^([^:]+)(:(\d+))?$/
        file, line = $1, $3
        editor! file, line
      else
        raise ArgumentError, "Invalid location"
      end
    end

    def editor! file, line = nil
      cmd = editor_cmd(file, line)
      log "Using editor: #{cmd}"
      begin
        system! cmd
      rescue
        $stderr.puts "  #{self}: ERROR: #{cmd}: #{$!.inspect}"
      end
    end

    def editor_cmd file, line = nil
      file = File.expand_path(file)
      line = nil if line && line.empty?
      editor = self.editor
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

    def system! cmd
      Process.fork do
        system(cmd)
      end
    end

    def log msg
      $stderr.puts "  #{self.class}: #{msg}"
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

