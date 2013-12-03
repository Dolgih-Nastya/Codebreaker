
module Codebreaker
  class Game
    MAX_NUMBER_OF_ATTEMPTS=5
    STRING_SIZE = 4
    attr_reader :number, :number_of_attempts, :count_of_hints , :player, :guess_checker

    def initialize(player)
      @number_of_attempts=0;
      @count_of_hints =0;
      @number=""
      @player=player
      generate
    end

    def string_for(guess)
      result = ""
      num_of_minuses=0;
      STRING_SIZE.times do |i|
         if number[i]==guess.value[i]
           result<<"+"
         elsif number.include? guess.value[i]
            num_of_minuses+=1
         end
      end
      num_of_minuses.times {result<<"-"}
      result
    end

    def result_of(guess)
         @number_of_attempts+=1
         string=string_for(guess)
         if string=="++++"
           win(string)   #win
         elsif @number_of_attempts<MAX_NUMBER_OF_ATTEMPTS
           continue(string) #continue
         elsif @number_of_attempts==MAX_NUMBER_OF_ATTEMPTS
           loose(string) #loose
          end
    end

    def checker_for_win(string)
      GuessChecker.new(:message=>"Congratulations! You are winner",
                       :number_of_attempts=>@number_of_attempts,
                       :string=>string)
    end

    def checker_for_continue(string)
      GuessChecker.new(:message=>"Game is continue",
                       :number_of_attempts=>@number_of_attempts,
                       :string=>string)
    end

    def checker_for_loose(string)
      GuessChecker.new(:message=>"Game is over",
                       :number_of_attempts=>@number_of_attempts,
                       :string=>string)
    end

    def win(string)
      write_results_to_file(:status=>"win")
      checker_for_win(string)
    end

    def loose (string)
      write_results_to_file(:status=>"lost")
      checker_for_loose(string)
    end

    def continue(string)
      checker_for_continue(string)
    end

    def write_results_to_file (options={})
      f_name = "/tmp/new_file.txt"
     # File.delete(f_name) if File.exist?(f_name)
      File.open(f_name, 'w') { |file| file.write(" Player: #{@player.name} finished game.\n Status: #{options[:status]}.\n Number of attempts: #{@number_of_attempts}") }
    end

    def can_use_hint?
      @count_of_hints<1? true : false
    end

    def take_hint
      if can_use_hint?
        position = rand(3)
        @count_of_hints+=1
        "There is #{take_digit(position).chr} digit in the secret number"
      else
        "You have not hints"
      end
    end

    def take_digit(position)
      @number[position]
    end

    private
    def generate
      STRING_SIZE.times do
        @number << (rand(5)+1).to_s
      end
    end
  end
end