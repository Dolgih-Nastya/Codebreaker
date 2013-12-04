require 'spec_helper'
module Codebreaker
  describe View do
    context "create player" do
      let(:view) {View.new}
      it "should show greeting" do
        view.as_null_object
        view.should_receive(:puts).with('Hello! It is a code breaker game!')
        view.create_player
      end
      it "should ask user name"  do
        view.as_null_object
        view.should_receive(:puts).with("Input your name, please")
        view.create_player
      end

      it "should create player"   do
        view.stub(:gets).and_return("Vasya")
        player=view.create_player
        expect(player.name).to eq("Vasya")
      end
    end

    context "make one guess" do
      let(:view) {View.new}
      it "should ask a guess" do
        view.as_null_object
        view.should_receive(:puts).with("Input code")
        view.make_guess
      end


      it "should show warning message if guess is invalid" do
        view.as_null_object
        view.stub(:gets).and_return("abcd")
        view.should_receive(:puts).with("Your guess is invalid. Your guess should contain four numbers from 1 to 6")
        view.make_guess
      end

      it "should return checker for guess " do
        result=view.make_guess
        expect(result).to be_a(GuessChecker)
      end
    end

    context "ask for hint" do
      let(:view) {View.new}
      it "should propose hint" do
        view.should_receive(:puts).with("Would you like to use hint?")
        view.ask_for_hint
      end

      it "should give hint if player answer was 'y' " do
         view.stub(:gets).and_return('y')
         view.game.should_receive(:take_hint)
         view.ask_for_hint
      end
    end


    context "play one game " do
      let(:view) {View.new}
      before {
        view.stub(:can_use_hint).and_return(true)
        view.stub(:ask_for_hint)
      }
      it "should propose hint if user can user has not use it before" do
        view.should_receive(:ask_for_hint)
        view.stub(:make_guess).and_return{GuessChecker.new}
        view.play_one_game
      end

      it "should suggest user to make guess while game is continue" do
        view.should_receive(:make_guess).exactly(2).times
        view.stub(:make_guess).and_return(GuessChecker.new(:message=>'Game is continue'),
                                          GuessChecker.new('Game is over'))
        view.play_one_game
      end

      it "should show each guess result while game is continue" do
        view.should_receive(:puts).exactly(4).times
        view.stub(:make_guess).and_return(GuessChecker.new(:message=>'Game is continue'),
                                          GuessChecker.new(:message=>'Game is continue'),
                                          GuessChecker.new(:message=>'Game is continue'),
                                          GuessChecker.new('Game is over'))
        view.play_one_game
      end
    end

    context "play game with player" do
      let(:view) {View.new}
      before {view.stub(:player).and_return{Player.new("Vasya")}}
      it "should ask for game" do
        view.as_null_object
        view.should_receive(:puts).with("Would you like to play with me, Vasya?")
        view.play
      end

      it "should play if answer for game was 'y'" do
        view.stub(:gets).and_return('y','y', 'y' 'n')
        view.should_receive(:play_one_game).exactly(2).times
        view.stub(:play_one_game)
        view.play
      end
    end
 end
end
