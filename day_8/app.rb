# frozen_string_literal: true
require 'ostruct'

def tree_1(_input = nil)
  file = File.open('input_full.txt')
  maps = []
  file.readlines.map(&:chomp).each_with_index do |line, idx|
    maps << line.split('').map(&:to_i)
  end

  # VISIBLE IF
  # is on one edge row 0 / last row / first column / last column

  visible = []
  other = []

  firt_row_index = 0
  firt_col_index = 0
  height_size = maps.size
  width_size = maps.first.size
  last_row = height_size - 1
  last_col = width_size - 1

  maps.each_with_index do |trees, row|
    trees.each_with_index do |tree, col|

      # EDGE ALWAYS VISIBLE
      if (row == 0 && col == 0) ||
        (row == 0 && col == last_col) ||
        (row == last_row && col == 0) ||
        (row == last_row && col == last_col) ||
        (row == 0  && (col != 0 && col!= last_col)) ||
        (row == last_row) && (col != 0 && col!= last_col) ||
        (col == 0) && (row != 0 && row!= last_row) ||
        (col == last_col) && (row != 0 && row!= last_row)
        visible << tree
      else
        tree_to_right = maps[row][col+1..width_size]
        tree_to_left = maps[row][0 .. col-1]

        cursor = row
        tree_to_top = []
        while cursor >= 0
          tree_to_top << maps[cursor-1][col] if (cursor-1) >= 0
          cursor = cursor -1
        end

        tree_to_bottom = []
        cursor = row
        while cursor >= last_row
          tree_to_bottom << maps[cursor+1][col] if (cursor+1) >= 0
          cursor = cursor -1
        end

        valid_right = tree_to_right.map {|v| tree > v}.uniq == [true]
        valid_left = tree_to_left.map {|v| tree > v}.uniq == [true]
        valid_top = tree_to_top.map {|v| tree > v}.uniq == [true]
        valid_bottom = tree_to_bottom.map {|v| tree > v}.uniq == [true]

        visible << tree if valid_right || valid_left || valid_top || valid_bottom
      end
    end
  end
  pp visible.size
end

def on_edge(row, col)

end

def tree_2(_input = nil)
end



tree_1
tree_2
