# frozen_string_literal: true

require "net/http"
require "uri"


module Ollama
  module Dsl
    class Client
      def initialize(host: "http://localhost:11434")
        @ollama_host = URI(host)
      end

      def stream(path)
        uri = "#{@ollama_host} #{path}".strip
        req = Net::HTTP::Post.new(uri, { "Content-Type" => "application/json" })
      end
    end
  end
end
