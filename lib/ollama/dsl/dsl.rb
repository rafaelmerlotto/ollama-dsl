# frozen_string_literal: true

module Ollama
  module Dsl
    class DSL
      attr_accessor :prompt 

      def initialize(session)
        @session = session  # Object store messages
        @events = {}        # Callback hash to handle streaming events
        @model = "llama3"   # Default model
        @prompt = nil       
        @then = nil
      end

      # method DSL sugar
      def model(name) = @model = name
      def system(text) = @session.add("system", text)
      def user(text)   = @session.add("user", text)

      # streaming callback 
      def on_chunk(&blk) = @events[:chunk] = blk
      def on_done(&blk)  = @events[:done]  = blk

      # flash helper
      def flash = @session.flash if @session.respond_to?(:flash)

     # chaining - create a new Dsl instance
      def then(&blk)
        @then = DSL.new(@session).instance_eval(&blk)
        self
      end

      # execute action
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
