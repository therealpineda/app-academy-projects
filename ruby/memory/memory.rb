require_relative 'board'
require_relative 'card'

class MemoryGame
  attr_reader :board
  attr_accessor :prev_guess

  def initialize(board)
    @board = board
    @prev_guess = nil
  end

  def get_guess
    while true
      print "Please enter a guess [row, col] : "
      guess = gets.chomp
      break if board.valid_pos?(guess)
      puts "Invalid guess."
    end
    parse(guess)
  end

  def make_guess(guessed_pos)
    board.reveal(guessed_pos)
    if prev_guess.nil?
      self.prev_guess = guessed_pos
    else
      board.render
      if board[prev_guess].value == board[guessed_pos].value
        puts "Match!"
      else
        puts "No match..."
        board[prev_guess].hide
        board[guessed_pos].hide
      end
      system("sleep 2")
      self.prev_guess = nil
    end
  end

  def over?
    board.won?
  end

  def parse(guess)
    guess.split(",").map(&:to_i)
  end

  def play
    until over?
      board.render
      while true
        guessed_pos = get_guess
        break unless board[guessed_pos].face_up
        puts "That card is already face-up"
      end
      make_guess(guessed_pos)
    end
    puts "You win."
  end

end

if __FILE__ == $0
  g = MemoryGame.new(Board.new(4))
  g.play

end
