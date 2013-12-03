require 'spec_helper'
module Codebreaker
  describe GuessChecker do
    context "should have such fields :message, :string, :number_of_attempts" do
      let(:checker) {GuessChecker.new(:message=>"message",:number_of_attempts=>5,:string=>"string")}
      it "should have message" do
        expect(checker.message).to eq "message"
      end

      it "should have string" do
        expect(checker.string).to eq "string"
      end

      it "should have number of attempts"   do
         expect(checker.number_of_attempts). to eq 5
      end
    end

    context "it should have result of the guess" do

      it "should have all fields if they are not nil" do
        checker=GuessChecker.new(:message=>"message",:number_of_attempts=>5,:string=>"string")
        expect(checker.result).to eq    "Result is: string\n Number of attempts you have used is: 5\n message\n "

      end

      it "should not have message if it is nil" do
        checker=GuessChecker.new(:number_of_attempts=>5,:string=>"string")
        expect(checker.result).to eq    "Result is: string\n Number of attempts you have used is: 5\n "
      end

      it "should not have string if it is nil" do
        checker=GuessChecker.new(:message=>"message",:number_of_attempts=>5)
        expect(checker.result).to eq    "Number of attempts you have used is: 5\n message\n "

      end

      it "should not have number_of_attempts if it is nil " do
        checker=GuessChecker.new(:message=>"message",:string=>"string")
        expect(checker.result).to eq    "Result is: string\n message\n "
      end
   end
  end
end