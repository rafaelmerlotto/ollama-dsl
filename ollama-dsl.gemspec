# frozen_string_literal: true

require_relative "lib/ollama/dsl/version"

Gem::Specification.new do |spec|
  spec.name = "ollama-dsl"
  spec.version = Ollama::Dsl::VERSION
  spec.authors = ["Rafael"]
  spec.email = ["rafaelmerlotto@gmail.com"]

  spec.summary     = "A simple Ruby DSL for interacting with Ollama LLMs, allowing streaming and structured prompts."
  spec.description = "Ollama DSL provides an easy-to-use Ruby interface to communicate with Ollama local or remote language models. It supports building prompts with system/user roles, handling streaming responses, and chaining prompts seamlessly."
  spec.homepage = "https://github.com/rafaelmerlotto/ollama-dsl"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://example.com"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rafaelmerlotto/ollama-dsl"
  spec.metadata["changelog_uri"] = "https://github.com/rafaelmerlotto/ollama-dsl/blob/main/CHANGELOG.md"


  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
