# frozen_string_literal: true
require 'ostruct'

class App
  def rope_1(_input = nil)

    # MOOVE
    # TO RIGH
    # .TH. --> .T.H --> ..TH
    #
    #  TO LEFT
    # ..HT --> .H.T --> .HT.
    #
    # TO BOTTOM
    #    .T. --> .T. --> ...
    #    .H. --> ... --> .T.
    #    ... --> .H. --> .H.
    # TO UP
    #    ... --> .H. --> .H.
    #    .H. --> ... --> .T.
    #    .T. --> .H. --> ...
    #
    # .....    ..H..    ..H..
    # ..H.. -> ..... -> ..T..
    # .T...    .T...    .....
    #
    # .....    .....    .....
    # ..H.. -> ...H. -> ..TH.
    # .T...    .T...    .....
    # .....    .....    .....

    file_path = File.expand_path("../input_map.txt", __FILE__)
    file      = File.open(file_path)

    map  = Map.new
    data = []
    file.readlines.map(&:chomp).each_with_index do |line, y|
      line.split(' ').each do |x|
        direction, value = x.split(' ')
        map.move(direction, value.to_i)
      end
    end
  end
end

class Map
  attr_accessor :maps, :coords

  def initialize(input = nil)
    @input  = input
    @head   = { x: 0, y: 0 }
    @tail   = { x: 0, y: 0 }
    @maps   = []
    @coords = []
    @cursor = { x: 0, y: 0 }

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
    # All combination position
    # 1 ) si meme colone / ligne, ecart > 1
    # Tail se positionnera meme ligne / colonne a pour reduire ecard a 0
    # 2 ) si T et H diagonal, H part verticalement
    #     --> T diagonal se réaligne avec H sur la verticalement
    # 3 ) Si T et H diagonal, H par horizontalement
    #     --> T diagonal se réaligne avec H horizatelement
    # un pattern se déssine
    # ( right / left / up / down ) moove de 1 ou -1 dans la meme direction
    # ()
    @coords << @tail unless @coords.include? @tail
  end

  def tail_need_update?
    !( head_pos == tail_pos ||
    head_pos == tail_right ||
    head_pos == tail_left ||
    head_pos == tail_up ||
    head_pos == tail_down ||
    head_pos == tail_diag_up_right ||
    head_pos == tail_diag_up_left ||
    head_pos == tail_diag_down_right ||
    head_pos == tail_diag_down_left)
  end

  def head_pos() [@head[:x], @head[:y]] end
  def tail_pos() [@tail[:x], @tail[:y]] end
  def tail_right() [@tail[:x]+1, @tail[:y]] end
  def tail_left() [@tail[:x]-1, @tail[:y]] end
  def tail_up() [@tail[:x], @tail[:y]+1] end
  def tail_down() [@tail[:x], @tail[:y]-1] end
  def tail_diag_up_right() [@tail[:x]+1, @tail[:y]+1] end
  def tail_diag_up_left() [@tail[:x]-1, @tail[:y]+1] end
  def tail_diag_down_right() [@tail[:x]+1, @tail[:y]-1] end
  def tail_diag_down_left() [@tail[:x]-1, @tail[:y]-1] end


  def move_right(value)
    value.times do |_|
      @head[:x] = @head[:x] + 1
      update_tail_position if tail_need_update?
    end
  end

  def move_left(value)
    value.times do |_|
      @head[:x] = @head[:x] - 1
      @coords << @head unless @coords.include? @head
    end
  end

  def move_up(value)
    value.times do |_|
      @head[:y] = @head[:y] + 1
      @coords << @head unless @coords.include? @head
    end
  end

  def move_down(value)
    value.times do |_|
      @head[:y] = @head[:y] - 1
      @coords << @head unless @coords.include? @head
    end
  end

  def printpp
    return pp @maps

    @maps.each do |y|
      pp y.join
    end
  end
end

App.new.rope_1
