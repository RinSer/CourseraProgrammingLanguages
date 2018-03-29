## Solution template for Guess The Word practice problem (section 7)

require_relative './section-7-provided'

class ExtendedGuessTheWordGame < GuessTheWordGame
  ## YOUR CODE HERE
end

class ExtendedSecretWord < SecretWord
  ## YOUR CODE HERE
  def initialize word
    @guesses = [];
    self.word = word
    self.pattern = self.word.gsub(/[a-zA-Z]/, '-')
  end

  def valid_guess? guess
    guess.length == 1 && guess.match(/[a-zA-Z]/) && !(@guesses.include? guess.downcase)
  end

  def guess_letter! letter
    self.word.chars.each_with_index do |l, i|
        if letter.casecmp(l) == 0
            self.pattern[i] = self.word[i]
        end
    end if found = self.word.chars.index{|l| letter.casecmp(l) == 0}
    # Add letter to guesses if not found
    @guesses.push(letter.downcase)
    found
  end
end

## Change to `false` to run the original game
if true
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
else
  GuessTheWordGame.new(SecretWord).play
end
