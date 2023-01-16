require_relative 'input'

def scoring(input = nil)

  values = {}
  ('a'..'z').to_a.zip ( (1..26).to_a).each do |kv|
    values[kv.first] = kv.last
  end
  ('A'..'Z').to_a.zip ( (27..52).to_a).each do |kv|
    values[kv.first] = kv.last
  end

  ww = []
  sum_points = fetch_input.split("\n").map do |pack|
    start = (pack.size/2)-1
    data = []
    data << pack[0..start].split('')
    data << pack[start+1..pack.size].split('')
    char =  (data.first & data.last).first
    pp " #{char}, #{values[char] || 0}"
    values[char] || 0
  end.sum
  pp sum_points
end

def scoring_2(input = nil)
  values = {}
  ('a'..'z').to_a.zip ( (1..26).to_a).each do |kv|
    values[kv.first] = kv.last
  end
  ('A'..'Z').to_a.zip ( (27..52).to_a).each do |kv|
    values[kv.first] = kv.last
  end


  sliced_points = fetch_input.split("\n").each_slice(3).map do |packs|
    packs = packs.map {|pack| pack.split('')}
    char = (packs[0] & packs[1] & packs[2]).first
    values[char] || 0
  end.sum

  pp sliced_points
end

scoring_2(fetch_input_2)
pp '-----------------------------------------------------------'
#scoring_3(fetch_input)