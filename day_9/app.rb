# frozen_string_literal: true
require 'ostruct'

class App
  def rope_1(_input = nil)

    file_path = File.expand_path("../input.txt", __FILE__)
    file = File.open(file_path)

    map = Map.new
    file.readlines.map(&:chomp).each_with_index do |line, y|
      direction, value = line.split(' ')
      map.move(direction, value.to_i)
    end

    pp map.coords.size
  end

  def rope_2(_input = nil)

    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)

    map = Map3.new
    file.readlines.map(&:chomp).each_with_index do |line, y|
      direction, value = line.split(' ')
      map.move(direction, value.to_i)
    end

    pp map.coords.size
  end
end

class Map3
  attr_accessor :maps, :coords
  attr_reader :direction, :head, :tails

  def initialize(input = nil)
    @input = input
    @head = { x: 0, y: 0 }
    @tails = [{ x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 },
              { x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 },
              { x: 0, y: 0 }, { x: 0, y: 0 }, { x: 0, y: 0 }
    ]
    @maps = []
    @coords = []
    @cursor = { x: 0, y: 0 }
    @direction = nil

    add_coord(@tails[0].dup)
  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, y|
      direction, value = line.split(' ')
      move(direction, value.to_i)
    end

    self
  end

  def data_to_read(input)
    return file.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end

  def move(direction, value)
    @direction = direction
    case direction
    when 'L' then move_left(value)
    when 'R' then move_right(value)
    when 'U' then move_up(value)
    when 'D' then move_down(value)
    else
    end
    @coords
  end

  def update_tail_position(index)
    tmp_tail = @tails[index].dup

    xtail = @tails[index][:x]
    ytail = @tails[index][:y]

    xhead = index == 0 ? @head[:x] : @tails[index - 1][:x]
    yhead = index == 0 ? @head[:y] : @tails[index - 1][:y]

    tmp_tail[:x] = xtail - 1 if yhead == ytail && xhead == xtail - 2
    tmp_tail[:x] = xtail + 1 if yhead == ytail && xhead == xtail + 2
    tmp_tail[:y] = ytail + 1 if xhead == xtail && yhead == ytail + 2
    tmp_tail[:y] = ytail - 1 if xhead == xtail && yhead == ytail - 2

    if xhead == xtail + 2 && yhead == ytail + 1 ||
      xhead == xtail + 1 && yhead == ytail + 2 ||
      xhead == xtail + 2 && yhead == ytail + 2
      tmp_tail[:x] = xtail + 1
      tmp_tail[:y] = ytail + 1
    end

    if xhead == xtail - 2 && yhead == ytail + 1 ||
      xhead == xtail - 1 && yhead == ytail + 2 ||
      xhead == xtail - 2 && yhead == ytail + 2
      tmp_tail[:x] = xtail - 1
      tmp_tail[:y] = ytail + 1
    end

    if xhead == xtail + 2 && yhead == ytail - 1 ||
      xhead == xtail + 1 && yhead == ytail - 2 ||
      xhead == xtail + 2 && yhead == ytail - 2
      tmp_tail[:x] = xtail + 1
      tmp_tail[:y] = ytail - 1
    end

    if xhead == xtail - 2 && yhead == ytail - 1 ||
      xhead == xtail - 1 && yhead == ytail - 2 ||
      xhead == xtail - 2 && yhead == ytail - 2
      tmp_tail[:x] = xtail - 1
      tmp_tail[:y] = ytail - 1
    end

    add_coord(tmp_tail) if index == 8
    @tails[index] = tmp_tail
    @coords
  end

  def tail_need_update?(index)
    head_pos = index == 0 ? head_pos_ : tail_pos(index - 1)
    status = !(head_pos == tail_pos(index) ||
      head_pos == tail_right(index) ||
      head_pos == tail_left(index) ||
      head_pos == tail_up(index) ||
      head_pos == tail_down(index) ||
      head_pos == tail_diag_up_right(index) ||
      head_pos == tail_diag_up_left(index) ||
      head_pos == tail_diag_down_right(index) ||
      head_pos == tail_diag_down_left(index))
    status
  end

  def head_pos_()
    [@head[:x], @head[:y]]
  end

  def tail_pos(index)
    [@tails[index][:x], @tails[index][:y]]
  end

  def tail_right(index)
    [@tails[index][:x] + 1, @tails[index][:y]]
  end

  def tail_left(index)
    [@tails[index][:x] - 1, @tails[index][:y]]
  end

  def tail_up(index)
    [@tails[index][:x], @tails[index][:y] + 1]
  end

  def tail_down(index)
    [@tails[index][:x], @tails[index][:y] - 1]
  end

  def tail_diag_up_right(index)
    [@tails[index][:x] + 1, @tails[index][:y] + 1]
  end

  def tail_diag_up_left(index)
    [@tails[index][:x] - 1, @tails[index][:y] + 1]
  end

  def tail_diag_down_right(index)
    [@tails[index][:x] + 1, @tails[index][:y] - 1]
  end

  def tail_diag_down_left(index)
    [@tails[index][:x] - 1, @tails[index][:y] - 1]
  end

  def move_right(value)
    value.times do |_|
      @head[:x] = @head[:x] + 1
      pp 'R ---------------------------'
      (0 .. 8).each do |index|
        update_tail_position(index) if tail_need_update?(index)
      end
      pp 'TAILS AFTER UPDATE'
      #pp @tails
    end
  end

  def move_left(value)
    value.times do |_|
      @head[:x] = @head[:x] - 1
      pp 'L ---------------------------'
      (0 .. 8).each do |index|
        update_tail_position(index) if tail_need_update?(index)
      end
    end
  end

  def move_up(value)
    value.times do |_|
      @head[:y] = @head[:y] + 1
      pp 'U ------------------------------------------'
      (0 .. 8).each do |index|
        update_tail_position(index) if tail_need_update?(index)
      end
      #pp @tails
    end
  end

  def move_down(value)
    value.times do |_|
      @head[:y] = @head[:y] - 1
      pp 'D ---------------------------'

      (0 .. 8).each do |index|
        update_tail_position(index) if tail_need_update?(index)
      end
    end
  end

  private

  def add_coord(coord)
    @coords << coord unless @coords.include?(coord)
  end
end

class Map
  attr_accessor :maps, :coords
  attr_reader :direction, :head, :tail

  def initialize(input = nil)
    @input = input
    @head = { x: 0, y: 0 }
    @tail = { x: 0, y: 0 }
    @maps = []
    @coords = []
    @cursor = { x: 0, y: 0 }
    @direction = nil

    add_coord(@tail.clone)
  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, y|
      direction, value = line.split(' ')
      move(direction, value.to_i)
    end

    self
  end

  def data_to_read(input)
    return file.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end

  def move(direction, value)

    @direction = direction
    case direction
    when 'L' then move_left(value)
    when 'R' then move_right(value)
    when 'U' then move_up(value)
    when 'D' then move_down(value)
    else
    end
    @coords
  end

  def update_tail_position

    tmp_tail = @tail.dup

    if direction == 'R'
      ## RR
      if ytail == yhead && xhead == xtail + 2
        tmp_tail[:x] = xtail + 1
        add_coord(tmp_tail)
      end

      # RUR
      if (xtail + 2 == xhead) && (ytail + 1 == yhead)
        tmp_tail[:x] = xtail + 1
        tmp_tail[:y] = ytail + 1
        add_coord(tmp_tail)
      end

      # RDR
      if (xtail + 2 == xhead) && (ytail - 1 == yhead)
        tmp_tail[:x] = xtail + 1
        tmp_tail[:y] = ytail - 1
        add_coord(tmp_tail)
      end
    end

    if direction == 'L'
      # LL
      if xtail - 2 == xhead && ytail == yhead
        tmp_tail[:x] = xtail - 1
        add_coord(tmp_tail)
      end
      # LUL
      if xtail - 2 == xhead && ytail + 1 == yhead
        tmp_tail[:y] = ytail + 1
        tmp_tail[:x] = xtail - 1
        add_coord(tmp_tail)
      end
      # LDL
      if xtail - 2 == xhead && ytail - 1 == yhead
        tmp_tail[:y] = ytail - 1
        tmp_tail[:x] = xtail - 1
        add_coord(tmp_tail)
      end
    end

    if direction == 'U'
      # UU
      if xhead == xtail && ytail + 2 == yhead
        tmp_tail[:y] = ytail + 1
        add_coord(tmp_tail)
      end

      # LUU
      if xtail - 1 == xhead && ytail + 2 == yhead
        tmp_tail[:y] = ytail + 1
        tmp_tail[:x] = xtail - 1
        add_coord(tmp_tail)
      end

      # RUU
      if xhead == xtail + 1 && ytail + 2 == yhead
        tmp_tail[:x] = xtail + 1
        tmp_tail[:y] = ytail + 1
        add_coord(tmp_tail)
      end
    end

    if direction == 'D'
      # DD
      if xtail == xhead && ytail - 2 == yhead
        tmp_tail[:y] = ytail - 1
        add_coord(tmp_tail)
      end

      # LDD
      if xtail - 1 == xhead && ytail - 2 == yhead
        tmp_tail[:y] = ytail - 1
        tmp_tail[:x] = xtail - 1
        add_coord(tmp_tail)
      end

      # RDD
      if xtail + 1 == xhead && ytail - 2 == yhead
        tmp_tail[:x] = xtail + 1
        tmp_tail[:y] = ytail - 1
        add_coord(tmp_tail)
      end
    end

    @tail = tmp_tail
    @coords
  end

  def tail_need_update?
    !(head_pos == tail_pos ||
      head_pos == tail_right ||
      head_pos == tail_left ||
      head_pos == tail_up ||
      head_pos == tail_down ||
      head_pos == tail_diag_up_right ||
      head_pos == tail_diag_up_left ||
      head_pos == tail_diag_down_right ||
      head_pos == tail_diag_down_left)
  end

  def head_pos()
    [@head[:x], @head[:y]]
  end

  def xhead()
    @head[:x]
  end

  def yhead()
    @head[:y]
  end

  def ytail()
    @tail[:y]
  end

  def xtail()
    @tail[:x]
  end

  def tail_pos()
    [@tail[:x], @tail[:y]]
  end

  def tail_right()
    [@tail[:x] + 1, @tail[:y]]
  end

  def tail_left()
    [@tail[:x] - 1, @tail[:y]]
  end

  def tail_up()
    [@tail[:x], @tail[:y] + 1]
  end

  def tail_down()
    [@tail[:x], @tail[:y] - 1]
  end

  def tail_diag_up_right()
    [@tail[:x] + 1, @tail[:y] + 1]
  end

  def tail_diag_up_left()
    [@tail[:x] - 1, @tail[:y] + 1]
  end

  def tail_diag_down_right()
    [@tail[:x] + 1, @tail[:y] - 1]
  end

  def tail_diag_down_left()
    [@tail[:x] - 1, @tail[:y] - 1]
  end

  def move_right(value)
    value.times do |_|
      @head[:x] = @head[:x] + 1
      update_tail_position if tail_need_update?
    end
  end

  def move_left(value)
    value.times do |_|
      @head[:x] = @head[:x] - 1
      update_tail_position if tail_need_update?
    end
  end

  def move_up(value)
    value.times do |_|
      @head[:y] = @head[:y] + 1
      update_tail_position if tail_need_update?
    end
  end

  def move_down(value)
    value.times do |_|
      @head[:y] = @head[:y] - 1
      update_tail_position if tail_need_update?
    end
  end

  def printpp
    return pp @maps

    @maps.each do |y|
      pp y.join
    end
  end

  private

  def add_coord(coord)
    @coords << coord unless @coords.include?(coord)
  end
end

class Hash
  def format
    self.values.join
  end
end

#App.new.rope_1
App.new.rope_2


