# frozen_string_literal: true
$LOAD_PATH.unshift(File.expand_path(".", __dir__))

require_relative "dsl/session"
require_relative "dsl/dsl"
require_relative "dsl/client"

session = Ollama::Dsl::Session.new
dsl = Ollama::Dsl::DSL.new(session)


dsl.model("llama3")
dsl.system("You are a marketing expert assistant.")
dsl.user("Write a catchy Instagram post title about artisanal coffee.")

dsl.on_chunk { |token| print token }
dsl.on_done { |full_text| puts "\n\nFinal response:\n#{full_text}" }

dsl.execute
