module Codebreaker
class GuessChecker
  attr_reader :message, :number_of_attempts, :string
 def initialize(options = {})
    @message=options[:message]
    @number_of_attempts=options[:number_of_attempts]
    @string=options[:string]
 end

  def result
    string=""
    string<<"Result is: #{@string}\n " if @string
    string<<"Number of attempts you have used is: #{@number_of_attempts}\n "  if @number_of_attempts
    string<<"#{@message}\n " if @message
    string
  end
end
end