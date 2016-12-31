require 'set'

class WordChainer

  attr_reader :dictionary, :all_seen_words
  attr_accessor :current_words

  def initialize(source, dict_filename = "dict.txt")
    @dictionary = create_dict(source, dict_filename).to_set
  end

  def adjacent_words(word)
    adjacent = []
    dictionary.each do |dict|
      if word[1..-1] == dict[1..-1]
        adjacent << dict
      elsif word[0..-2] == dict[0..-2]
        adjacent << dict
      else
        (0...word.length).each do |i|
          if word[0..i] == dict[0..i] && word[(i + 2)..-1] == dict[(i + 2)..-1]
            adjacent << dict
          end
        end
      end
    end
    adjacent
  end

  def build_path(source, target)
    path = [target]
      while true
        next_step = all_seen_words[path.last]
        break unless next_step
        path << all_seen_words[path.last]
      end

      if path.last == source
        puts "The path is: #{path.reverse.join(" --> ")}"
      else
        puts "No path found..."
      end
  end

  def create_dict(word, file)
    File.readlines(file).map(&:chomp).select { |w| w.length == word.length }
  end

  def explore_current_words
    new_current_words = []
    current_words.each do |current_word|

      adjacent_words(current_word).each do |adj_word|
        unless all_seen_words.include?(adj_word)
          new_current_words << adj_word
          all_seen_words[adj_word] = current_word
        end
      end
    end
    # new_current_words.each do |new_word|
    #   puts "#{new_word} came from: #{all_seen_words[new_word]}"
    # end
    self.current_words = new_current_words
  end

  def run(source, target)
    if source.length == target.length
      puts "Building path from \"#{source}\" to \"#{target}\"..."
      @current_words = [source]
      @all_seen_words = { source => nil }
      until current_words.empty? || all_seen_words.has_key?(target)
        explore_current_words
      end
      build_path(source, target)
    else
      puts "Words must be of the same length..."
    end
  end

end

if __FILE__ == $0
  source = ARGV.shift
  target = ARGV.shift
  w = WordChainer.new(source)
  w.run(source, target)
end
