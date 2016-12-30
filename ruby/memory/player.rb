require_relative 'board'

class Player
  attr_reader :name

  def initialize(name = "Dave")
    @name = name
  end

  def get_guess(board)
    while true
      print "Please enter a guess [row, col] : "
      guess = gets.chomp
      break if board.valid_pos?(guess)
      puts "Invalid guess."
    end
    parse(guess)
  end

  def parse(guess)
    guess.split(",").map(&:to_i)
  end

  # dummy methods
  def receive_match(*pos)
  end

  def receive_revealed_card(pos, value)
  end
end

class ComputerPlayer < Player

  attr_reader :known_cards, :matched_positions

  def initialize(name = "HAL")
    super(name)
    @known_cards = Hash.new { |hash, key| hash[key] = [] }
    @matched_positions = []
  end

  def remaining_board_pos(board)
    all_board_pos = []
    board.grid.each_index do |i|
      board.grid.each_index do |j|
        all_board_pos << [i,j]
      end
    end

    remain = all_board_pos - matched_positions
    known_cards.values.each do |positions|
      remain.delete_if { |pos| positions.include?(pos) }
    end
    remain
  end

  def get_guess(board)
    match = known_cards.values.find { |v| v.length == 2 }
    if match
      board[match.first].face_up ? match.last : match.first
    else
      remaining_board_pos(board).sample
    end
  end

  def receive_revealed_card(pos, value)
    known_cards[value] << pos unless known_cards[value].length == 2
  end

  def receive_match(*positions)
    positions.each { |pos| matched_positions << pos }
    known_cards.delete_if { |k,v| v.sort == positions.sort }
  end

end
