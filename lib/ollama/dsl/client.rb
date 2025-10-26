# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Ollama
  module Dsl
    class Client
      def initialize(host: "http://localhost:11434")
        @ollama_host = URI(host)
      end

      def stream(path, payload)

        uri = URI("#{@ollama_host}#{path}")

        # POST request
        req = Net::HTTP::Post.new(uri, { "Content-Type" => "application/json" })
        req.body = payload.to_json

        # Response streaming
        Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req) do |response|
            response.read_body do |chunk|
              begin
                json = JSON.parse(chunk)
                yield json if block_given?
              rescue JSON::ParserError
              end
            end
          end
        end
      end
    end
  end
end
