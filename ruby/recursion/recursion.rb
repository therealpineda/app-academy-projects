## Recursion exercises

def range(first, last)
  return [] if first > last
  prev_range = range(first, last - 1)
  prev_range + [last]
end

def sum_recur(array)
  return array.first if array.length == 1
  prev_sum = sum_recur(array.drop(1))
  array.first + prev_sum
end

def sum_iter(array)
  sum = 0
  array.each do |num|
    sum += num
  end
  sum
end

def exp1(base, power)
  return 1 if power == 0
  prev_exp = exp1(base, power - 1)
  prev_exp * base
end

def exp2(base, power)
  return 1 if power == 0
  return base if power == 1
  half_power = power / 2

  prev_exp = exp2(base, half_power)
  new_product = prev_exp * prev_exp

  power.odd? ? new_product *= base : new_product

end

class Array
  def deep_dup
    duped = []

    each do |el|
      if el.is_a?(Array)
        duped << el.deep_dup
      else
        duped << el
      end
    end

    duped
  end
end

def fibs(n_fibs)
  return [] if n_fibs == 0
  return [0,1].take(n_fibs) if (1..2) === n_fibs
  prev_fibs = fibs(n_fibs - 1)
  prev_fibs << (prev_fibs[-2] + prev_fibs[-1])
end

def subsets(array)
  return [[]] if array.empty?
  prev_subs = subsets(array[0..-2])
  new_el = array.last
  new_subs = prev_subs.deep_dup
  new_subs.each do |new_sub|
    new_sub << new_el
  end
  prev_subs + new_subs
end

def permutations(array)
  return [array] if array.length == 1
  prev_perms = permutations(array[0..-2])
  next_perm = array.last
  new_perms = []
  prev_perms.each do |prev_perm|
    (0..prev_perm.length).each do |i|
      new_perms << prev_perm.take(i) + [next_perm] + prev_perm.drop(i)
    end
  end
  new_perms
end

def bsearch(array, target)
  return nil if array.length == 0
  return 0 if array.first == target && array.length == 1
  mid = array.length / 2
  left = array.take(mid)
  right = array.drop(mid + 1)

  case target <=> array[mid]
  when -1
    bsearch(left, target)
  when 0
    mid
  when 1
    right_pos = bsearch(right, target)
    right_pos ? left.length + 1 + right_pos : nil
  end

end

def merge_sort(array)
  return [] if array.empty?
  return array if array.length == 1

  mid = array.length / 2
  left_sorted = merge_sort(array.take(mid))
  right_sorted = merge_sort(array.drop(mid))

  merge(left_sorted, right_sorted)
end

def merge(left, right)
  sorted = []

  until left.empty? || right.empty?
    case left.first <=> right.first
    when -1
      sorted << left.shift
    when 0
      sorted << left.shift
    when 1
      sorted << right.shift
    end
  end

  sorted.concat(left).concat(right)

end

def greedy_change(amount, coins = [25, 10, 5, 1])
  return [] if coins.empty?
  coin = coins.first
  count = amount / coin
  current_coin = [coin] * count
  new_amount = amount - (coin * count)
  prev_change = greedy_change(new_amount, coins.drop(1))
  current_coin + prev_change
end

def better_change(amount, coins = [25, 10, 5, 1])
  return [] if coins.empty?
  best_change = nil
  coins.each_with_index do |coin, i|
    next if amount < coin

    change = [coin]

    remain = amount - coin
    new_change = better_change(remain, coins)

    change += new_change if new_change

    if best_change.nil? || best_change.length > change.length
      best_change = change
    end
  end
  best_change
end
