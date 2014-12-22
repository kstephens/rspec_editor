module RspecEditor
  case RSpec::Version::STRING
  when /^2\./
    require 'rspec_editor/rspec2/formatter'
    Formatter = Rspec2::Formatter
  when /^3\./
    require 'rspec_editor/rspec3/formatter'
    Formatter = Rspec3::Formatter
  else
    raise "#{self}: RSpec VERSION #{RSpec::Version::STRING} is unsupported"
  end
end
