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

