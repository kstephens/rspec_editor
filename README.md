# RspecEditor

RSpec 2 and 3 Formatter that interfaces with your editor: emacs, vim,
etc.

Writes a file that can be interpreted as `grep -n` output.
Then invokes your editor.
Works well with emacs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_editor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_editor

## Usage

   $ export RSPEC_EDITOR=emacsclient
   $ export RSPEC_EDITOR_OUT=rspec.errors.log
   $ rspec -require rspec_editor -f d -f RspecEditor::Formatter

## Contributing

1. Fork it ( https://github.com/kstephens/rspec_editor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
