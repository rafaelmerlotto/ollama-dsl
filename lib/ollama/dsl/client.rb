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

      # Used by DSL for streaming responses
      def stream(path, payload)
        uri = URI("#{@ollama_host}#{path}")

        request = Net::HTTP::Post.new(
          uri,
          { "Content-Type" => "application/json" }
        )

        request.body = payload.merge(stream: true).to_json

        Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request) do |response|
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

      # Used by Agent for tool calling
      def chat(model:, messages:, tools: nil)
        payload = {
          model: model,
          messages: messages,
          stream: false
        }

        payload[:tools] = tools if tools && !tools.empty?

        post("/api/chat", payload)
      end

      private

      def post(path, payload)
        uri = URI("#{@ollama_host}#{path}")

        request = Net::HTTP::Post.new(
          uri,
          { "Content-Type" => "application/json" }
        )

        request.body = payload.to_json

        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end

        unless response.is_a?(Net::HTTPSuccess)
          raise "Ollama request failed: #{response.code} #{response.body}"
        end

        JSON.parse(response.body)
      end
    end
  end
end
