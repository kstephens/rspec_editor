# -*- ruby -*-
guard 'rspec', cmd: 'bundle exec rspec --require rspec_editor.rb -f d --format RspecEditor::Formatter' do
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
end

