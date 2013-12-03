require 'spec_helper'

module Codebreaker
  describe Game do
    let(:player) {Player.new("Nastya")}
    let(:game) { Game.new(player) }
    context "#start:" do

      it "should have number" do
        expect(game.number).not_to be_empty
      end

      it "should have valid number" do
        guess = Guess.new game.number
        expect(guess).to be_valid
      end

      it "should have a player" do
        expect(game.player).to eq player
      end

      it "number of used hints should be equal 0 " do
        expect(game.count_of_hints).to eq 0
      end

      it "should have number of used attempts to be equal 0" do
        expect(game.number_of_attempts).to eq 0
      end
    end

    context "code-breaker tries to guess number" do
      it "result of right guess should be ++++"   do
        user_guess = Guess.new game.number
        expect(game.string_for(user_guess)).to eq("++++")
      end

      it "result of wrong guess should be empty string" do
        wrong_number="0000"
        user_guess = Guess.new wrong_number
        expect(game.string_for(user_guess)).to be_empty
      end

      it "result of string than matches not exactly should contain -" do
         new_number=game.number.reverse
         new_number[3]="0"
         user_guess = Guess.new new_number
         expect(game.string_for(user_guess)).to include "-"
      end

      it "result of string that contain two symbols than matches exactly contain ++ "     do
          new_number= game.number.clone
          new_number[2], new_number[3]="0", "0"
          user_guess = Guess.new new_number
          expect(game.string_for(user_guess)).to eq "++"
      end

      context  "code-breaker wins game " do
        let(:user_guess){Guess.new game.number}
        it "should be present ++++ string in the result" do
          string = game.result_of(user_guess).string
          expect(string).to eq "++++"
        end

        it "should have congratulations message" do
          message = game.result_of(user_guess).message
          expect(message).to include "Congratulations!"
        end

        it "should have number of attempts of code breaker" do
          number_of_attempts = game.result_of(user_guess).number_of_attempts
          expect(number_of_attempts).to eq(1)
        end

        it "should write result of success to file" do
          game.should_receive(:write_results_to_file).with(:status=>"win")
          game.result_of(user_guess)
        end

        it "should write win result to file" do
          game.result_of(user_guess)
          string_from_file=File.read('/tmp/new_file.txt')
          expect(string_from_file).to eq " Player: Nastya finished game.\n Status: win.\n Number of attempts: 1"

        end
      end

      context "code breaker continue the game " do
        let(:user_guess){Guess.new "0000"}
        it "should have status 'Game is continue' when game is not over"  do
          message = game.result_of(user_guess).message
          expect(message).to include "Game is continue"
        end


        it "should have string when game is not over"  do
          string = game.result_of(user_guess).string
          expect(string).not_to be_nil
        end

        it "should have number of attempts even the game is not over" do
          number_of_attempts = game.result_of(user_guess).number_of_attempts
          expect(number_of_attempts).to eq(1)
        end
      end

      context "number of attempts should increase while codebreaker making guesses" do
        let(:user_guess){Guess.new "0000"}
        it "number of used attempts should increase by 1"  do
          expect{game.result_of(user_guess)}.to change{game.number_of_attempts}.from(0).to(1)
          expect{game.result_of(user_guess)}.to change{game.number_of_attempts}.by(1)
        end

        it "number of used attempts should increase by 1"  do
          expect{game.result_of(user_guess)}.to change{game.number_of_attempts}.by(1)
        end
      end

      context "code - breaker looses the game" do
        let(:user_guess){Guess.new "0000"}
        let! (:checker) {GuessChecker.new}
        before(:each) {
          5.times do
          @checker=game.result_of(user_guess)
          end
        }
        it "should have 'Game is over' message" do
          expect(@checker.message).to eq "Game is over"
        end

        it "should have number of attempts" do
          expect(@checker.number_of_attempts).to eq 5
        end

        it "should have string "  do
          expect(@checker.string).not_to be_nil
        end

        it "results of lost should be written to file " do
          game=Game.new(player)
          4.times do
            @checker=game.result_of(user_guess)
          end
          game.should_receive(:write_results_to_file).with(:status=>"lost")
          game.result_of(user_guess)
        end
        it "should write loosing result to file" do
          game.result_of(user_guess)
          string_from_file=File.read('/tmp/new_file.txt')
          expect(string_from_file).to eq " Player: Nastya finished game.\n Status: lost.\n Number of attempts: 5"
        end
      end

      context "user should have one hint" do
        let(:game) {Game.new(player)}
        it "code breaker can use hint if he has not used it before" do
          can_use_hint=game.can_use_hint?
          expect(can_use_hint).to be_true
        end

        it "code breaker can not use hint if he has used it before" do
          game.take_hint
          can_use_hint=game.can_use_hint?
          expect(can_use_hint).to be_false
        end

        it "should have right digit in the position" do
          digit=game.take_digit(2)
          expect(digit).to eq(game.number[2])
        end

        it "message for hint should have hint"  do
          message=game.take_hint
          expect(message).to include "digit in the secret number"
        end

        it "message for hint should have right message for hint"   do
          digit="2"
          game.stub(:take_digit).and_return(digit[0].ord)
          message=game.take_hint
          expect(message).to include "There is #{digit} digit in the secret number"
        end

        it "should have not get hint message if he has used hint before" do
          game.take_hint
          message=game.take_hint
          expect(message).to eq "You have not hints"
        end
      end

      context "should be new game if old game is over" do
        let(:game) {Game.new(player)}
        let(:new_game){Game.new(player)}
        it "old and new game should be difference" do
          expect(new_game).not_to eq game
        end

        it "number of used attempts for new game should be equal 0"  do
          expect(new_game.number_of_attempts).to eq 0
        end
      end

    end


  end
end