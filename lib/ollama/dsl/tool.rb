# frozen_string_literal: true

module Ollama
  module Dsl
    class Tool
      attr_reader :name, :description, :parameters

      def initialize(name, description, parameters:, &block)
        @name = name.to_s
        @description = description
        @parameters = parameters
        @block = block
      end

      def definition
        {
          type: "function",
          function: {
            name: @name,
            description: @description,
            parameters: @parameters
          }
        }
      end

      def call(arguments = {})
        @block.call(**arguments.transform_keys(&:to_sym))
      end
    end
  end
end