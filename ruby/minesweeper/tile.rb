class Tile
  attr_reader :board, :position, :bombed, :flagged
  attr_accessor :revealed, :n_bomb_count

  def initialize(board, pos, bombed = false)
    @board = board
    @position = pos
    @bombed = bombed
    @flagged = false
    @revealed = false
    @n_bomb_count = 0
  end

  def count
    self.n_bomb_count = neighbors.select { |t| t.bombed }.length
  end

  def inspect
    b = "(b)" if bombed
    revealed ? r = "(_)" : r = "(*)"
    "#{position}#{r}#{b}"
    # "[B:#{bombed} F:#{flagged} R:#{revealed}]"
  end

  def to_s
    if flagged
      "F"
    elsif revealed
      if n_bomb_count == 0
        "_"
      else
        "#{n_bomb_count}"
      end
    else
      "*"
    end
  end

  def get_n_positions
    row, col = position
    neigh_pos = [
      [row - 1, col],
      [row - 1, col + 1],
      [row, col + 1],
      [row + 1, col + 1],
      [row + 1, col],
      [row + 1, col - 1],
      [row, col - 1],
      [row - 1, col - 1]
    ]
    neigh_pos.select do |pos|
      pos.all? { |num| (0...board.size) === num }
    end
  end

  def neighbors
    positions = get_n_positions
    positions.inject([]) do |neighbors, pos|
      neighbors << board[pos]
    end
  end

  def reveal
    self.revealed = true
  end
end
