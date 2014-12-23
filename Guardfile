# -*- ruby -*-
guard 'rspec', cmd: 'bundle exec rspec --require rspec_editor -f d --format RspecEditor::Formatter' do
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/.*_spec.rb$})
  watch(%r{spec_helper\.rb$})   { "spec" }
  watch(%r{^spec/rspec\d+/.*_spec_example.rb$}) { "spec/rspec_spec.rb" }
end

