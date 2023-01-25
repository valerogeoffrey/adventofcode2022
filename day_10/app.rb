# frozen_string_literal: true
require 'ostruct'

class App
  def day101(_input = nil)

    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Display.new.process(file)

    pp displayer.force
  end

  def day102(_input = nil)
    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Display2.new.process(file)

    pp displayer.display.map(&:join)
  end
end

class Display
  attr_accessor :cycles, :u, :force

  def initialize(input= nil)
    @cycles = 0
    @u = 1
    @force = 0
    @input = input
  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, y|
      action, value = line.split(' ')
      case action
      when 'noop' then handle_noop
      when 'addx' then handle_addx(value.to_i)
      end
    end

    self
  end

  def handle_noop
    update_cycle(1)
    update_force
  end

  def handle_addx(value)
    tmp_cycle = @cycles.dup
    loop do
      update_cycle(1)
      update_force
      break if @cycles == tmp_cycle + 2
    end
    update_register(value)
  end

  def update_force
    if @cycles % 40 == 20
      @force = @force + (@cycles * @u)
    end
  end

  def update_cycle(value)
    @cycles = @cycles + value
  end

  def update_register(value)
    @u = @u + value
  end

  def data_to_read(input)
    return input.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end
end
class Display2
  attr_accessor :cycles, :u, :force, :display

  def initialize(input= nil)
    @cycles = 0
    @u = 1
    @force = 0
    @input = input
    @display = [[],[],[],[],[],[]]
    @pixel = 0
  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, y|
      action, value = line.split(' ')
      case action
      when 'noop' then handle_noop
      when 'addx' then handle_addx(value.to_i)
      end
    end

    self
  end

  def handle_noop
    update_cycle(1)
    draw
    update_force
  end

  def handle_addx(value)
    tmp_cycle = @cycles.dup
    loop do
      update_cycle(1)
      draw
      update_force
      break if @cycles == tmp_cycle + 2
    end
    update_register(value)
  end

  def draw
    if @cycles/40 >= 0 && @cycles/40 <= 5
      cursor = @display[@cycles/40]
      symbol = [@u-1,@u,@u+1].include?(@pixel) ? '#' : '.'
      cursor << symbol
    end
    @pixel = @pixel == 39 ? 0 : @pixel+1
  end

  def update_force
    if @cycles % 40 == 20
      @force = @force + (@cycles * @u)
    end
  end

  def update_cycle(value)
    @cycles = @cycles + value
  end

  def update_register(value)
    @u = @u + value
  end

  def data_to_read(input)
    return input.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end
end
App.new.day101
App.new.day102


