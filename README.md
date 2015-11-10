# Gherkin3Reformat

A script to reformat Gherkin3 code, to a consistent style.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gherkin3_reformat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gherkin3_reformat

## Usage

```bash
gherkin3_reformat features/myfeature.feature > features/myfeature_reformatted.feature
gherkin3_reformat --replace features/*.feature
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gherkin3_reformat.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

