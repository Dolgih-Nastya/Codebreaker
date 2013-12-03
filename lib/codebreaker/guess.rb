module Codebreaker
  class Guess

    attr_reader :errors
    attr_reader :value

    def initialize value
      @value = value
    end

    def valid?
      @errors = []
      @errors << "Should have numbers from 1 to 6" unless @value =~ /^[1-6]{4}$/
      @errors.empty?
    end

  end
end