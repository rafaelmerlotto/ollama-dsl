# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "ollama/dsl/session"
require "ollama/dsl/agent"

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

result = agent.run(
  "Create a file called hello.txt containing exactly: Hello from my AI agent."
)

puts result
