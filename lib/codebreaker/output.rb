module Codebreaker
class Output
  def start_game
    create_player
    play
  end
  def create_player
    puts "Hello! It is a code breaker game!"
    puts "Input your name, please"
    name=gets.chomp
    @player=Player.new(name)
  end

  def play
    puts "Would you like to play with me, #{@player.name}?"
    answer=gets.chomp
    while (answer=="y") do
      play_one_game
      puts "Would you like to play with me again?"
      answer=gets.chomp
    end
    puts "Game is over"
  end

  def make_guess(game)
    puts "Input code"
    guess=Guess.new(gets.chomp)
    if guess.valid?
      checker=game.result_of(guess)
    else
      checker=GuessChecker.new(:message=>'Game is continue')
      puts "Your guess is invalid. Your guess should contain four numbers from 1 to 6"
    end
    checker
  end

  def ask_for_hint(game)
    puts "Would you like to use hint?"
    answer= gets.chomp
    if answer =="y"
      puts game.take_hint
    end
  end

  def play_one_game
    game=Game.new(@player)
    begin
      if game.can_use_hint?
        ask_for_hint(game)
      end
      checker=make_guess(game)
      puts checker.result
    end while (checker.message=='Game is continue')
  end

 end
end