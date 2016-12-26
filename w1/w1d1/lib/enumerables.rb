# Iteration Exercises
# Enumerables and Arrays

#  Extend the Array class to include
# ### My Each
# ### My Map
# ### My Select
# ### My Reject
# ### My Inject
# ### My Any
# ### My All
# ### My Flatten
# ### My Zip
# ### My Rotate
# ### My Join
# ### My Reverse
# - [ ] `bubble_sort!(&prc)`
# - [ ] `bubble_sort(&prc)`

#  Also write methods for:
# `factors(num)`
# `substrings(string)`
# `subwords(word, dictionary)`
# `doubler(array)`
# `concatenate(array)`


class Array

  def my_each(&prc)
    i = 0
    until i == self.length
      prc.call(self[i])
      i += 1
    end
    self
  end

  def my_map(&prc)
    mapped = []
    my_each do |el|
      mapped << prc.call(el)
    end
    mapped
  end

  def my_select(&prc)
    selected = []
    my_each do |el|
      selected << el if prc.call(el)
    end
    selected
  end

  def my_reject(&prc)
    rejected = []
    my_each do |el|
      rejected << el unless prc.call(el)
    end
    rejected
  end

  def my_inject(accumulator = nil, &prc)
    i = 0
    if accumulator.nil?
      accumulator = self.first
      array = self.drop(1)
      i += 1
    else
      array = self.dup
    end

    array.each do |el|
      accumulator = prc.call(accumulator, el)
    end


    accumulator
  end

  def my_any?(&prc)
    my_each do |el|
      return true if prc.call(el)
    end
    false
  end

  def my_all?(&prc)
    my_each do |el|
      return false unless prc.call(el)
    end
    true
  end

  def my_flatten
    flattened = []
    my_each do |el|
      if el.is_a?(Array)
        flattened += el.my_flatten
      else
        flattened << el
      end
    end
    flattened
  end

  def my_zip(*arrays)
    zipped = []
    i = 0
    until i == self.length
      current = [self[i]]
      arrays.each do |array|
        current << array[i]
      end
      zipped << current
      i += 1
    end
    zipped
  end

  def my_rotate(rotation = 1)
      if rotation > 0
        rotation.times { self.push(self.shift) }
      else
        rotation *= -1
        rotation.times { self.unshift(self.pop) }
      end
      self
  end

  def my_join(separator = "")
    # self * separator    <-- shortcut for join
    joined = ""
    each_with_index do |el, i|
      next if i == length - 1
      joined << "#{el}#{separator}"
    end
    joined << self.last
  end

  def my_reverse
    reversed = []
    (0...length).to_a.sort { |el1, el2| el2 <=> el1 }.each do |i|
      reversed << self[i]
    end
    reversed
  end

  def bubble_sort(&prc)
    dup.bubble_sort!(&prc)
  end

  def bubble_sort!(&prc)
    return self if self.length <= 1
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    sorted = false
    until sorted == true
      sorted = true
      (0...self.length - 1).each do |i|
        if prc.call(self[i], self[i + 1]) == 1
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end
      end
    end
    self
  end

end

def factors(num)
  facts = [1]
  (2..num).each do |n|
    facts << n if num % n == 0
  end
  facts
end

def subwords(string, dictionary)
  subs = []
  letters = string.split("")
  letters.each_index do |i|
    letters.each_index do |j|
      next unless i <= j
      slice = string[i..j]
      if dictionary.include?(slice) && !subs.include?(slice)
        subs << slice
      end
    end
  end
  subs
end

def doubler(array)
  doubles = []
  array.each do |num|
    doubles << num * 2
  end
  doubles
end

def concatenate(array)
  array.inject("") do |str, word|
    str << word
  end
end
