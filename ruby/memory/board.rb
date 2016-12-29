require_relative 'card'

class Board
  attr_reader :grid, :size

  def initialize(size = 4)
    @size = size
    @grid = Array.new(size) { Array.new(size) }
    populate(size)
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, new_value)
    row, col = pos
    grid[row][col] = new_value
  end

  def populate(size)
    cards = ('a'..'z').to_a
    cards *= 2 until cards.length > size
    values = cards.take((size * size) / 2) * 2
    values.shuffle!
    (0...size).each do |row|
      (0...size).each do |col|
        pos = [row, col]
        self[pos] = Card.new(values.shift)
      end
    end
  end

  def valid_pos?(guess)
    pos = guess.split(",")
    return false unless pos.length == 2
    pos.each { |n| return false unless (n =~ /[0-9]/) && (0..size) === n.to_i }
  end

  def render
    system("clear")
    puts "Memory Game!"
    puts "  " + (0...size).to_a.join("")
    grid.each_with_index do |row, i|
      print "#{i} "
      row.each { |card| print card }
      puts "\n"
    end
  end

  def reveal(guessed_pos)
    row, col = guessed_pos
    self[guessed_pos].reveal unless self[guessed_pos].face_up
  end

  def won?
    grid.flatten.all? { |card| card.face_up }
  end

end

if __FILE__ == $0
  b = Board.new
  b.render
end
