# frozen_string_literal: true

require 'json'
require_relative "dsl/version"


module Ollama
  module Dsl
    class Error < StandardError; end
    
    def self.run(&block)
      DSL.new(Session.new).instance_eval(&block).execute
    end
  
  end
end
