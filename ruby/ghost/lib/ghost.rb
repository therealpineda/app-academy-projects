require_relative 'player'

class Game
  attr_reader :dictionary, :players, :losses
  attr_accessor :current_player, :previous_player, :fragment

  def initialize(players, dictionary = "../dict.txt")
    @fragment = ""
    @dictionary = create_dictionary(dictionary)
    @players = players
    @current_player = players.sample
    @previous_player = nil
    @losses = Hash.new(0)
  end

  def create_dictionary(dictionary)
    File.readlines(dictionary).map(&:chomp)
  end

  def display
    system("clear")
    puts "G-H-O-S-T"
    # if losses.values.any? { |v| v > 0 }
      puts "\nScoreboard"
      players.each do |player|
        count = losses[player]
        # next unless count > 0
        puts "#{player.name}: #{"GHOST"[0...count]}"
      end
    # end
    puts
    puts "-" * 30
    puts "Current fragment: #{fragment}"
    puts "-" * 30
    puts
  end

  def eliminate_player
    puts "GHOST! #{previous_player.name} has been eliminated..."
    players.delete_if { |pl| pl == previous_player }
  end

  def game_over?
    players.count == 1
  end

  def next_player!
    self.previous_player = current_player
    next_idx = (players.index(current_player) + 1) % players.length
    self.current_player = players[next_idx]
  end

  def play
    until game_over?
      until round_over?
        play_round(current_player)
        next_player!
      end
      display
      puts "#{previous_player.name} loses. They spelled: \"#{fragment}\""
      update_score
      system("sleep 2")
      reset_board
    end
      display
      puts "#{players.first.name} wins!\n\n"
  end

  def play_round(player)
    new_letter = take_turn(player)
    update_fragment(new_letter)
  end

  def reset_board
    self.fragment = ""
  end

  def round_over?
    dictionary.include?(fragment)
  end

  def take_turn(player)
    while true
      display
      letter = player.get_letter(fragment, players.length)
      break if valid_play?(letter)
    end
    letter
  end

  def update_fragment(new_letter)
    fragment << new_letter
  end

  def update_score
    losses[previous_player] += 1
    eliminate_player if losses[previous_player] == 5
  end

  def valid_play?(letter)
    check_frag = "#{fragment}#{letter}"
    dictionary.each do |word|
      return true if word[0...check_frag.length] == check_frag
    end
    puts "\"#{check_frag}\" is not the beginning of any word!"
    system("sleep 2")
    false
  end

end

if __FILE__ == $PROGRAM_NAME
  input = ""
  puts "Welcome to GHOST. Please enter the first player name:"
  names = []
  until input == "\n" && names.length >= 1
    input = gets
    names << input.chomp unless input == "\n"
    puts "Please enter next player, or [ENTER] when all players have entered."
  end
  players = [AIPlayer.new("HAL")]
  names.each do |name|
    players << Player.new(name)
  end
  game = Game.new(players)
  game.play
end
