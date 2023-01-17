require_relative 'input'
require 'ostruct'

def stacking(input = nil)
  file = File.open("input_full.txt")
  matrice = []
  data_move = []
  file.readlines.map(&:chomp).each_with_index do |line, idx|
    words = line.split(' ')
    next if words.first == '1' || words.first == nil

    if words.first == 'move'
      data = line.split(' ').select do |char|
        (1 .. 99).include? char.to_i
      end
      data_move << OpenStruct.new({ count: data[0].to_i, from: data[1].to_i - 1, to: data[2].to_i - 1 })
    else
      test_blocks = line.split('').each_slice(4).map do |blocks|
        blocks.select { |char| ('A' .. 'Z').to_a.include?(char) }.first
      end
      test_blocks.each_with_index do |letter, idx|
        matrice[idx] = [] unless matrice[idx].is_a?(Array)
        matrice[idx] << letter if ('A' .. 'Z').to_a.include?(letter)
      end
    end
  end
  matrice = matrice.map(&:reverse)

  data_move.each_with_index do |action, _|
    while action.count > 0
      if matrice[action.from].size > 0
        letter = matrice[action.from].pop
        matrice[action.to] << letter
      end
      action.count = action.count - 1
    end
  end

  pp matrice.each.map(&:last).join
end

def stacking_2(input = nil)
  file = File.open("input_full.txt")
  matrice = []
  data_move = []
  file.readlines.map(&:chomp).each_with_index do |line, idx|
    words = line.split(' ')
    next if words.first == '1' || words.first == nil

    if words.first == 'move'
      data = line.split(' ').select do |char|
        (1 .. 99).include? char.to_i
      end
      data_move << OpenStruct.new({ count: data[0].to_i, from: data[1].to_i, to: data[2].to_i })
    else
      test_blocks = line.split('').each_slice(4).map do |blocks|
        blocks.select { |char| ('A' .. 'Z').to_a.include?(char) }.first
      end
      test_blocks.each_with_index do |letter, idx|
        matrice[idx] = [] unless matrice[idx].is_a?(Array)
        matrice[idx] << letter if ('A' .. 'Z').to_a.include?(letter)
      end
    end
  end

  matrice = matrice.map(&:reverse)
  data_move.each_with_index do |action, idx|
    count, from, to = action.to_h.values
    row = matrice[from - 1]
    letters = row.reverse[0 .. count - 1].reverse
    matrice[to - 1] = matrice[to - 1] + letters
    ending = (matrice[from - 1].size) - (count+1)
    matrice[from - 1] = matrice[from - 1][0..ending]
  end
  pp matrice.each.map(&:last).join
end



bk1 = stacking_2(fetch_input_2)
pp bk1[:res]
