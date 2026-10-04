# Ollama::Dsl

[![Gem Version](https://badge.fury.io/rb/ollama-dsl.svg)](https://badge.fury.io/rb/ollama-dsl)
[![Documentation](https://img.shields.io/badge/docs-rubydoc.info-blue)](https://rubydoc.info/gems/ollama-dsl)

A Ruby DSL for interacting with Ollama LLMs, with support for streaming, structured prompts, agents, and tool calling.

Ollama DSL provides an easy-to-use Ruby interface for communicating with local or remote Ollama language models. It supports system and user prompts, streaming responses, prompt chaining, and building agents that can execute custom Ruby tools.

## Installation

Install the gem:

```bash
gem install ollama-dsl
```

Or add it to your `Gemfile`:

```ruby
gem "ollama-dsl"
```

Then run:

```bash
bundle install
```

If you want to use it directly from GitHub:

```ruby
gem "ollama-dsl", git: "https://github.com/rafaelmerlotto/ollama-dsl.git"
```

## Basic Example

```ruby
require "ollama/dsl"

Ollama::Dsl.run do
  model "llama3"

  system "You are a marketing expert assistant."
  user "Write a catchy Instagram post title about artisanal coffee."

  on_chunk { |token| print token }

  on_done do |text|
    puts "\n\nFinal response:\n#{text}"
  end

  self
end
```

## Agents

Ollama DSL also provides an `Agent` abstraction for building tool-enabled automations.

An agent can:

* Receive a user instruction
* Decide which registered tool to use
* Execute the tool in Ruby
* Send the tool result back to Ollama
* Continue the execution loop until the task is completed

### Example

```ruby
require "ollama/dsl"

session = Ollama::Dsl::Session.new

agent = Ollama::Dsl::Agent.new(
  session,
  model: "gpt-oss:20b"
)

agent.tool(
  "create_file",
  "Create a text file with the given filename and content.",
  parameters: {
    type: "object",
    properties: {
      filename: {
        type: "string",
        description: "The name of the file to create."
      },
      content: {
        type: "string",
        description: "The content to write into the file."
      }
    },
    required: ["filename", "content"]
  }
) do |filename:, content:|
  File.write(filename, content)

  "File #{filename} was created successfully."
end

puts agent.run(
  "Create a file called hello.txt containing Hello from my AI agent."
)
```

The agent uses Ollama's native tool calling capabilities to decide when a tool should be executed.

Tools are not limited to file operations. You can define tools for any Ruby automation your application needs.

For example:

```ruby
agent.tool("get_time", "Get the current time.", parameters: {
  type: "object",
  properties: {}
}) do
  Time.now.to_s
end
```

## Tool Calling

Tools consist of three main parts:

* A name
* A description
* A parameter schema and Ruby block

The description and parameter schema are sent to Ollama, allowing the model to decide when and how to use the tool.

The Ruby block contains the actual implementation that is executed by the agent.

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Run the test suite with:

```bash
bundle exec rspec
```

You can also run:

```bash
bundle exec rake
```

for the project's Rake tasks.

To open an interactive console:

```bash
bin/console
```

To install this gem onto your local machine:

```bash
bundle exec rake install
```

To release a new version, update the version number in `version.rb`, then run:

```bash
bundle exec rake release
```

This will create a git tag for the version, push the git commits and tag, and publish the gem to RubyGems.

## Contributing

Bug reports and pull requests are welcome on GitHub at:

https://github.com/rafaelmerlotto/ollama-dsl

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Code of Conduct](https://github.com/rafaelmerlotto/ollama-dsl/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with the Ollama::Dsl project's codebases, issue trackers and mailing lists is expected to adhere to the [Code of Conduct](https://github.com/rafaelmerlotto/ollama-dsl/blob/main/CODE_OF_CONDUCT.md).
