# frozen_string_literal: true
require 'ostruct'

class App
  def day111(_input = nil)

    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Service.new.process(file)
  end

  def day112(_input = nil)
    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Display2.new.process(file)

    pp displayer.display.map(&:join)
  end
end

class Service
  def initialize
    @monkeys = []
    @raw = []
    @i = 0
    @counters = []
    @item_id = 0
  end

  def process(input = nil)
    data_to_read(input).each_with_index do |line, _|
      @monkeys[@i] = [] if @monkeys[@i].nil?
      @monkeys[@i] << line.strip unless line == ''
      @i += 1 if line == ''
    end

    @monkeys.map! do |monkey_raw|
      init_monkey(monkey_raw)
    end

    @monkeys.each do |_|
      @counters << []
    end

    pp @monkeys.first.items
    (0 .. 1).each do |round|
      pp "ROUND: #{round}"
      @monkeys.each do |monkey|
        pp monkey.ident
      end
    end

    self
  end

  def init_monkey(monkey_raw)
    id = monkey_raw[0].split('').last.to_i
    items = monkey_raw[1].sub('Starting items: ', '').strip.split(',').map(&:to_i)
    items = items.map do |lvl|
      @item_id = @item_id + 1
      OpenStruct.new({ id: @item_id.dup, lvl: lvl })
    end

    divisible = monkey_raw[3].split('').last.to_i
    monkey_index_true = monkey_raw[4].split('').last.to_i
    monkey_index_false = monkey_raw[5].split('').last.to_i
    sym = monkey_raw[2].split('').select { |v| ['-', '+', '*'].include? v }.first
    value = monkey_raw[2].split(' ').last.to_i
    operation = ->(item) { item.send(sym.to_sym, value == 0 ? item : value) }
    OpenStruct.new({
                     ident: id,
                     items: items,
                     operation: operation,
                     divisible: divisible,
                     monkey_index_true: monkey_index_true,
                     monkey_index_false: monkey_index_false
                   }.dup)
  end

  def data_to_read(input)
    return input.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end
end

App.new.day111


