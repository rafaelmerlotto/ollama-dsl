# frozen_string_literal: true
require "rspec"
require_relative "../../lib/ollama/dsl/dsl"

RSpec.describe Ollama::Dsl do
  it "has a version number" do
    expect(Ollama::Dsl::VERSION).not_to be nil
  end

end
