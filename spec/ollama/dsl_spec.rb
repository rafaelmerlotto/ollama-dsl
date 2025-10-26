# frozen_string_literal: true
require "rspec"
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
end

