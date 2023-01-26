# frozen_string_literal: true
require 'ostruct'
require 'pry'

class App
  def day121(file: '')
    file_path = File.expand_path("../input#{file}.txt", __FILE__)
    file = File.open(file_path)
    displayer = Service.new.process(file)
  end

  def day122(_input = nil)
    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Service.new.process(file)
  end
end

class Service
  attr_reader :paths, :dict

  def initialize
    @paths = {}
    @cursors = {}
    @end = { x: 0, y: 0 }
    @reach = false
    @value = 'S'
    alphabet = ('a' .. 'z').to_a
    numbers = (1 .. 26).to_a
    @dict = alphabet.zip(numbers).to_h
    @dict['S'] = 999
    @dict['E'] = 0
    @map = []
    @path_id = 0
    @point_id = 0
  end

  def init_point(letter, row_id, column_id)
    valid = ->(value) { dict[letter] >= dict[value] || dict[value.next] == dict[letter] || value == 'E' }
    @point_id += 1
    OpenStruct.new(
      id: @point_id,
      x: column_id,
      y: row_id,
      letter: letter,
      value: dict[letter],
      "valid?" => valid
    )

  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, row_id|
      positions = line.split('').each_with_index.map { |letter, column_id| init_point(letter, row_id, column_id) }
      @map << positions
    end
    dig_path(path_id: @path_id, point: @map.first.first)

    binding.pry
  end

  def dig_path(path_id:, point:)
    @paths[@path_id] = [] if @paths[@path_id].nil?
    @paths[path_id] << point.id

    return if @reach == true
    if point.letter == 'E'
      @reach == true
      return
    end

    moves = available_moves_for(path_id, point)
    pp moves.size
    return dig_path(path_id: path_id, point: moves.first) if moves.size == 1

    moves.each do |point|
      @path_id += 1
      dig_path(path_id: @path_id, point: point)
    end
  end

  def available_moves_for(path_id, point)
    x = point.x
    y = point.y
    size_x = @map.first.size
    size_y = @map.size
    to_right = x + 1
    to_left = x -1
    to_down = y + 1
    to_up = y - 1
    points = []
    positions = []
    positions << @map.dig(y, to_right) if to_right <= size_x && x != size_x
    positions << @map.dig(y, to_left) if to_left >=0 && x != 0
    positions << @map.dig(to_down, x) if to_down <= size_y && y != size_y
    positions << @map.dig(to_up, x) if to_up <= 0 && y != 0

    positions.compact.each do |coord|
      pp "DEBUG:#{point.letter} x:#{coord.x} - y:#{coord.y} - letter: #{coord.letter}"
      next if @paths[path_id].include?(coord.id) || !point.valid?.call(coord.letter)
      points << coord
    end

    points
  end

  def debug_count
  end

  def data_to_read(input)
    return input.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end
end

class Integer
  def dig(*)
    nil
  end
end

App.new.day121(file: '',)
#App.new.day112


