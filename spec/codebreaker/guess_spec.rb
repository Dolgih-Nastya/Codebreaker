require 'spec_helper'

module Codebreaker
  describe Guess do
    context "#valid?:" do
      let (:not_valid_guess) { Guess.new("12345") }
      let (:valid_guess) { Guess.new("1234") }

      it "should return false if not valid" do
        expect(not_valid_guess).not_to be_valid
      end

      it "should return true if valid" do
        expect(valid_guess).to be_valid
      end

      it "should have numbers from 1 to 6" do
        guess = Guess.new("12345")
        guess.valid?
        expect(guess.errors).to include('Should have numbers from 1 to 6')
      end
    end

  end
end

