require 'spec_helper'
require 'rspec_editor'

RSpec.describe RspecEditor do
  let(:output) { "tmp/test.#{$$}.log" }
  let(:output_content) { File.read(output) }
  after { File.unlink(output) rescue nil }

  context "RSpec 2" do
    let(:version) { '~> 2.99' }
    let(:spec) { 'spec/rspec2/rspec2_spec_example.rb' }
    it "should write to output file" do
      run_rspec!
      validate_output!
    end
  end

  context "RSpec 3" do
    let(:version) { '~> 3.0' }
    let(:spec) { 'spec/rspec3/rspec3_spec_example.rb' }
    it "should write to output file" do
      run_rspec!
      validate_output!
    end
  end

  def validate_output!
    expect(output_content) .to match(/mode: grep;/m)
    expect(output_content) .to match(/mode: auto-revert;/m)
    expect(output_content) .to match(/default-directory: /m)
    expect(output_content) .to match(/_spec_example.rb:\d+: # RSpec \d fails/m)
  end

  def run_rspec!
    run_cmd! "rspec '_#{rspec_version}_' -I '#{RspecEditor.root_dir}/lib' --require rspec/version --require rspec_editor -f RspecEditor::Formatter #{spec}"
  end

  let(:rspec_version) { gem_version version }

  def run_cmd! cmd
    Bundler.with_clean_env do
      ENV.keys.grep(/^BUNDLE_/).each{|k| ENV.delete(k)}
      ENV['RSPEC_EDITOR']     = 'NONE'
      ENV['RSPEC_EDITOR_OUT'] = output
      $stderr.puts " Running: #{cmd}"
      system cmd
    end
  end

  def gem_version version
    version = Gem::Requirement.new(version)
    rspec_specs = all_installed_gems['rspec']
    specs_matching = rspec_specs.select{|g| version.satisfied_by?(g.version)}
    rspec_version = specs_matching.first.version.to_s
    # binding.pry
    rspec_version
  end

  # http://stackoverflow.com/questions/5177634/list-of-installed-gems
  def all_installed_gems
    Gem::Specification.all = nil
    result = Gem::Specification.sort_by{ |g| [g.version, g.name] }.reverse.group_by{ |g| g.name }
    Gem::Specification.reset
    result
  end

end

