# frozen_string_literal: true
require "rspec"
require "json"
require_relative "../../lib/ollama/dsl/dsl"

RSpec.describe Ollama::Dsl do
  it "has a version number" do
    expect(Ollama::Dsl::VERSION).not_to be nil
  end

end

RSpec.describe Ollama::Dsl::DSL do
  let(:session) { double("Session", add: nil, messages: []) }

  it "Set prompt" do
    dsl = described_class.new(session)
    dsl.prompt = "Hello world"
    expect(dsl.prompt).to eq("Hello world")
  end

  it "Check current ollama model" do
    dsl = described_class.new(session)
    dsl.model('llama3')
    expect(dsl.instance_variable_get(:@model)).to eq("llama3")  
  end
end

RSpec.describe Ollama::Dsl::Agent do
  let(:session) { double("Session", add: nil, messages: []) }

  let(:parameters) do
    {
      type: "object",
      properties: {
        filename: { type: "string" },
        content: { type: "string" }
      },
      required: ["filename", "content"]
    }
  end

  it "registers a tool" do
    agent = described_class.new(session)

    agent.tool(
      "create_file",
      "Create a text file",
      parameters: parameters
    ) do |filename:, content:|
      File.write(filename, content)
    end

    tool = agent.tools["create_file"]

    expect(tool).to be_a(Ollama::Dsl::Tool)
    expect(tool.name).to eq("create_file")
    expect(tool.description).to eq("Create a text file")
    expect(tool.parameters).to eq(parameters)
  end

end

RSpec.describe Ollama::Dsl::Tool do
  let(:parameters) do
    {
      type: "object",
      properties: {
        name: { type: "string" }
      },
      required: ["name"]
    }
  end

  it "returns the tool definition" do
    tool = described_class.new(
      "say_hello",
      "Say hello to a person",
      parameters: parameters
    )

    expect(tool.definition).to eq(
      {
        type: "function",
        function: {
          name: "say_hello",
          description: "Say hello to a person",
          parameters: parameters
        }
      }
    )
  end
end


