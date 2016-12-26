require 'byebug'

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_letter(_, _)
    while true
      print "#{name}, please enter a letter to add to the fragment: "
      letter = gets.chomp
      break if valid_entry?(letter)
      puts "Invalid entry."
    end
    letter
  end

  def valid_entry?(letter)
    unless letter =~ /[a-z, A-Z]/ && letter.length == 1
      puts "Please enter a letter"
      return false
    end
    true
  end
end


class AIPlayer < Player

  attr_accessor :dictionary, :winning_words

  def initialize(name)
    super(name)
    @dictionary = create_dictionary("../dict.txt")
    @winning_words = []
  end

  def create_dictionary(dictionary)
    File.readlines(dictionary).map(&:chomp)
  end

  def get_letter(fragment, num_players)
    words = dictionary.select do |word|
      word[0...fragment.length] == fragment
    end

    check_winners(fragment, num_players, words)

    unless winning_words.empty?
      words = winning_words
    end

    letter = words.sample[fragment.length]
    puts "#{name} selects: #{letter}"
    system("sleep 2")
    letter
  end

  def check_winners(fragment, num_players, words)
    f_length = fragment.length
    winning_word_length_range = ((2 + f_length)..(num_players + f_length))
    self.winning_words = words.select do |word|
      winning_word_length_range === word.length && !dictionary.include?(word[0..f_length])
    end

    debugger
  end
end
