require_relative 'player'
require_relative 'board'
require_relative 'card'

class MemoryGame
  attr_reader :board, :player
  attr_accessor :prev_guess

  def initialize(board, player)
    @board = board
    @player = player
    @prev_guess = nil
  end

  def make_guess(guessed_pos)
    board.reveal(guessed_pos)
    player.receive_revealed_card(guessed_pos, board[guessed_pos].value)
    if prev_guess.nil?
      self.prev_guess = guessed_pos
    else
      board.render
      if board[prev_guess].value == board[guessed_pos].value
        player.receive_match(prev_guess, guessed_pos)
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

  def play
    until over?
      board.render
      while true
        guessed_pos = player.get_guess(board)
        break unless board[guessed_pos].face_up
        # debugger
        puts "That card is already face-up"
      end
      make_guess(guessed_pos)
    end
    puts "You win."
  end

end

if __FILE__ == $0
  g = MemoryGame.new(Board.new(4), ComputerPlayer.new("Chris"))
  g.play

end
