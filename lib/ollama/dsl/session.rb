# frozen_string_literal: true

module Ollama
  module Dsl
    class Session
      attr_reader :messages, :flash

      def initialize
        @messages = []
        @flash = {}
      end

      def add(role, content)
        @messages << { role:, content: }
      end
    end
  end
end
