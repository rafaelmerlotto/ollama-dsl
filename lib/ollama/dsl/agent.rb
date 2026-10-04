# frozen_string_literal: true

require_relative "tool"
require_relative "client"

module Ollama
  module Dsl
    class Agent
      attr_reader :tools

      def initialize(session, model: "llama3")
        @session = session
        @model = model
        @tools = {}
        @client = Client.new
      end

      def tool(name, description, parameters:, &block)
        @tools[name.to_s] = Tool.new(
          name,
          description,
          parameters: parameters,
          &block
        )
      end

      def run(instruction)
        @session.add("user", instruction)

        loop do
          response = @client.chat(
            model: @model,
            messages: @session.messages,
            tools: tool_definitions
          )

          message = response.fetch("message")

          tool_calls = message["tool_calls"]

          if tool_calls.nil? || tool_calls.empty?
            final_answer = message["content"].to_s

            @session.add("assistant", final_answer)

            return final_answer
          end

          @session.messages << message

          tool_calls.each do |tool_call|
            execute_tool(tool_call)
          end
        end
      end

      private

      def tool_definitions
        @tools.values.map(&:definition)
      end

      def execute_tool(tool_call)
        function = tool_call.fetch("function")

        name = function.fetch("name")
        arguments = function["arguments"] || {}

        tool = @tools[name]

        raise "Unknown tool: #{name}" unless tool

        result = tool.call(arguments)

        @session.messages << {
          role: "tool",
          content: result.to_s
        }
      end
    end
  end
end
