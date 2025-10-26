# frozen_string_literal: true

module Ollama
  module Dsl
    class DSL
      def initialize(session)
        @session = session
        @events = {}
        @model = "llama3"
        @prompt = nil
        @then = nil
      end

      def model(name) = @model = name
      def prompt(text) = @prompt = text
      def system(text) = @session.add("system", text)
      def user(text)   = @session.add("user", text)

      def on_chunk(&blk) = @events[:chunk] = blk
      def on_done(&blk)  = @events[:done]  = blk

      def flash = @session.flash

      def then(&blk)
        @then = DSL.new(@session).instance_eval(&blk)
        self
      end

      def execute
        client = Client.new
        path = @session.messages.any? ? "/api/chat" : "/api/generate"
        payload = if path == "/api/chat"
                    { model: @model, messages: @session.messages }
                  else
                    { model: @model, prompt: @prompt }
                  end

        text = +""
        client.stream(path, payload) do |json|
          if json["response"]
            token = json["response"]
            text << token
            @events[:chunk]&.call(token)
          elsif json["message"]
            token = json["message"]["content"]
            text << token
            @events[:chunk]&.call(token)
          elsif json["done"]
            @events[:done]&.call(text)
          end
        end

        @then ? @then.execute : text
      end
    end
  end
end
