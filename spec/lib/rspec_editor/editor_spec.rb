require 'spec_helper'
require 'rspec_editor/editor'

module RspecEditor
  class Editor
    RSpec.describe Editor do
      subject do
        obj = Editor.new
        obj.editor = editor
        obj.output_file = output_file
        def obj.system! cmd ; @system = cmd ; end
        def obj.system ; @system ; end
        obj
      end
      let(:output_file) { "tmp/test.#{$$}.log" }
      after { File.unlink(output_file) rescue nil }
      let(:output_file_content) { File.read(output_file) }

      context "editor = emacs" do
        let(:editor) { "emacs" }
        it "writes an output file" do
          subject.open
          subject.puts "FOO"
          subject.close

          expect(output_file_content) .to include("-*- mode: grep")
          expect(output_file_content) .to include("FOO")
          expect(subject.system) .to match(%r{/emacsclient -q -n })
        end
      end

      context "editor = vim" do
        let(:editor) { "vim" }
        it "writes an output file" do
          subject.open
          subject.puts "FOO"
          subject.close

          expect(output_file_content) .to include("-*- mode: grep")
          expect(output_file_content) .to include("FOO")
          expect(subject.system) .to match(%r{vim --remote })
        end
      end
    end
  end
end
