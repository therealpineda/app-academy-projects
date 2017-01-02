require_relative 'tile'

class Board
  attr_reader :grid, :size

  def initialize(size = 9)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    populate
    @game_over = false
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, new_value)
    row, col = pos
    grid[row][col] = new_value
  end

  def populate
    grid.each_index do |row|
      grid.each_index do |col|
        pos = [row, col]
        rand(1..6) == 1 ? bombed = true : bombed = false
        self[pos] = Tile.new(self, pos, bombed)
      end
    end
  end

  def render
    puts "Board:"
    print "  "
    (0...grid.length).each do |i|
      print "#{i}"
    end
    grid.each_with_index do |row, i|
      print "\n#{i} "
      row.each do |col|
        print col
      end
    end
  end

  def reveal(pos)
    game_over = true if self[pos].bombed
    to_reveal = [self[pos]]
    until to_reveal.empty?
      to_reveal.each do |tile|
        tile.reveal
      end
      next_reveal = to_reveal.shift
      if next_reveal.count != 0
        next_reveal.neighbors.each do |tile|
          unless tile.bombed || tile.flagged || tile.revealed
            to_reveal << tile
          end
        end
      end
    end
  end

end



if __FILE__ == $0
  b = Board.new
  p b.grid
  print "Bombs: "
  p b.grid.flatten.count { |t| t.bombed }
  b.render
  b.reveal([0,0])
  b.render
  sleep 2
  b.reveal([3,3])
  b.render
end
