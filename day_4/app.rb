require_relative 'input'

def pairing(input = nil)
  pairs = input.split("\n").map do |packs|
    packs = packs.split(',').map do |pairs|
      pairs = pairs.split('-')
      (pairs.first..pairs.last).to_a
    end
    one_way = (packs.first - packs.last) == []
    second_way = (packs.last - packs.first) == []
    one_way || second_way
  end.select {|v| v == true}.size
  pp pairs
end

def pairing_2(input = nil)
  pairs = input.split("\n").map do |packs|
    packs = packs.split(',').map do |pairs|
      pairs = pairs.split('-')
      (pairs.first..pairs.last).to_a
    end
    (packs.first & packs.last).size > 0
  end.select {|v| v == true}.size
  pp pairs
end

pairing_2(fetch_input_2)
pp '-----------------------------------------------------------'
#scoring_(fetch_input)