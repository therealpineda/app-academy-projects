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

    puts "\nScoreboard"
    players.each do |player|
      rounds_lost = losses[player]
      puts "#{player.name}: #{"GHOST"[0...rounds_lost]}"
    end

    frag_display
  end

  def eliminate_player
    puts "GHOST! #{previous_player.name} has been eliminated..."
    players.delete(previous_player)
  end

  def frag_display
    puts
    puts "-" * 30
    puts "Current fragment: #{fragment}"
    puts "-" * 30
    puts
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
    check = "#{fragment}#{letter}"
    dictionary.each do |word|
      return true if word[0...check.length] == check
    end

    puts "\"#{check}\" is not the beginning of any word!"
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
  names.each { |name| players << Player.new(name) }
  game = Game.new(players)
  game.play
end
