# frozen_string_literal: true
require 'ostruct'

class App
  def tree_1(_input = nil)
    file = File.open('day_8/input_full.txt')
    maps = []
    file.readlines.map(&:chomp).each_with_index do |line, idx|
      maps << line.split('').map(&:to_i)
    end

    # VISIBLE IF
    # is on one edge row 0 / last row / first column / last column
    trees       = Set.new
    height_size = maps.size
    width_size  = maps.first.size
    last_row    = height_size - 1
    last_col    = width_size - 1

    maps.each_with_index do |list, row|
      list.each_with_index do |tree, col|
        pp tree if row == 97 && col == 2
        # EDGE ALWAYS VISIBLE
        if (row == 0 && col == 0) ||
          (row == 0 && col == last_col) ||
          (row == last_row && col == 0) ||
          (row == last_row && col == last_col) ||
          (row == 0 && (col != 0 && col != last_col)) ||
          (row == last_row) && (col != 0 && col != last_col) ||
          (col == 0) && (row != 0 && row != last_row) ||
          (col == last_col) && (row != 0 && row != last_row)

          trees << [row, col]
        else
          to_right = maps[row][col + 1 .. width_size]
          to_left  = maps[row][0 .. col - 1]

          cursor = row
          to_top = []
          while cursor >= 0
            to_top << maps[cursor - 1][col] if (cursor - 1) >= 0
            cursor = cursor -1
          end

          to_bottom = []
          cursor    = row
          while cursor <= last_row
            to_bottom << maps[cursor + 1][col] if (cursor + 1) <= last_row
            cursor = cursor +1
          end

          valid_right  = to_right.map { |v| tree > v }.uniq == [true]
          valid_left   = to_left.map { |v| tree > v }.uniq == [true]
          valid_top    = to_top.map { |v| tree > v }.uniq == [true]
          valid_bottom = to_bottom.map { |v| tree > v }.uniq == [true]

          trees << [row, col] if valid_right || valid_left || valid_top || valid_bottom
        end
      end
    end
    trees.size
  end

  def tree_2(_input = nil)
    file = File.open('input_full.txt')
    maps = []
    file.readlines.map(&:chomp).each_with_index do |line, idx|
      maps << line.split('').map(&:to_i)
    end

    # VISIBLE IF
    # is on one edge row 0 / last row / first column / last column
    trees       = []
    height_size = maps.size
    width_size  = maps.first.size
    last_row    = height_size - 1
    last_col    = width_size - 1

    maps.each_with_index do |list, row|
      list.each_with_index do |tree, col|
        pp tree if row == 97 && col == 2
        # EDGE ALWAYS VISIBLE
        if (row == 0 && col == 0) ||
          (row == 0 && col == last_col) ||
          (row == last_row && col == 0) ||
          (row == last_row && col == last_col) ||
          (row == 0 && (col != 0 && col != last_col)) ||
          (row == last_row) && (col != 0 && col != last_col) ||
          (col == 0) && (row != 0 && row != last_row) ||
          (col == last_col) && (row != 0 && row != last_row)
        else
          to_right = maps[row][col + 1 .. width_size]
          to_left  = maps[row][0 .. col - 1].reverse

          cursor = row
          to_top = []
          while cursor >= 0
            to_top << maps[cursor - 1][col] if (cursor - 1) >= 0
            cursor = cursor -1
          end

          to_bottom = []
          cursor    = row
          while cursor <= last_row
            to_bottom << maps[cursor + 1][col] if (cursor + 1) <= last_row
            cursor = cursor +1
          end

          distance_right = nil
          to_right.map.with_index do |v, i|
            distance_right = i + 1
            break if v >= tree
          end
          distance_right = distance_right || to_right.size

          distance_left = nil
          to_left.map.with_index do |v, i|
            distance_left = i + 1
            break if v >= tree
          end
          distance_left = distance_left || to_left.size

          distance_top = nil
          to_top.map.with_index do |v, i|
            distance_top = i + 1
            break if v >= tree
          end
          distance_top = distance_top || to_top.size

          distance_bottom = nil
          to_bottom.map.with_index do |v, i|
            distance_bottom = i + 1
            break if v >= tree
          end
          distance_bottom = distance_bottom || to_bottom.size
          d_total = distance_left * distance_bottom * distance_right * distance_top
          trees << d_total
        end
      end
    end
    [trees, maps]
  end
end
