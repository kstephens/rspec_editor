require "rspec_editor/version"

module RspecEditor
  def self.root_dir
    File.expand_path('../../', __FILE__)
  end
end
require 'rspec_editor/editor'
require 'rspec_editor/formatter'
