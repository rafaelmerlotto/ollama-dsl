# frozen_string_literal: true
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "ollama/dsl/session"
require "ollama/dsl/dsl"
require "ollama/dsl/client"

session = Ollama::Dsl::Session.new
dsl = Ollama::Dsl::DSL.new(session)


dsl.model("llama3")
dsl.system("You are a marketing expert assistant.")
dsl.user("Write a catchy Instagram post title about artisanal coffee.")

dsl.on_chunk { |token| print token }
dsl.on_done { |full_text| puts "\n\nFinal response:\n#{full_text}" }

dsl.execute
