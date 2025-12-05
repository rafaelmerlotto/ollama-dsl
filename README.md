# Ollama::Dsl

[![Gem Version](https://badge.fury.io/rb/ollama-dsl.svg)](https://badge.fury.io/rb/ollama-dsl)
[![Documentation](https://img.shields.io/badge/docs-rubydoc.info-blue)](https://rubydoc.info/gems/ollama-dsl)

A Ruby DSL for interacting with Ollama LLMs, allowing streaming and structured prompts.

Ollama DSL provides an easy-to-use Ruby interface to communicate with Ollama local or remote language models. It supports building prompts with system/user roles, handling streaming responses, and chaining prompts seamlessly.

## Usage

After installing the gem:

```bash
$ gem install ollama-dsl
```

Or in your `Gemfile`:

```ruby
gem 'ollama-dsl'
```

Then run:

```bash
$ bundle install
```

If you want to use it directly from GitHub:

```ruby
gem 'ollama-dsl', git: 'https://github.com/rafaelmerlotto/ollama-dsl.git'
```

## Basic Example

```ruby
require "ollama/dsl"

Ollama::Dsl.run do
  # Set the model
  model "llama3"

  # Add system and user prompts
  system "You are a marketing expert assistant."
  user "Write a catchy Instagram post title about artisanal coffee."

  # Optional: handle streaming tokens
  on_chunk { |token| print token }

  # Optional: handle the final response
  on_done { |text| puts "\n\nFinal response:\n#{text}" }

  self # Important: ensure the DSL object is returned for execution
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rafaelmerlotto/ollama-dsl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rafaelmerlotto/ollama-dsl/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ollama::Dsl project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rafaelmerlotto/ollama-dsl/blob/main/CODE_OF_CONDUCT.md).
