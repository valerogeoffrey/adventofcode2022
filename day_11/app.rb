# frozen_string_literal: true
require 'ostruct'
require 'pry'

class App
  def day111(file: '', round: 20)

    file_path = File.expand_path("../input#{file}.txt", __FILE__)
    file = File.open(file_path)
    displayer = Service.new.process(file, round)
  end

  def day112(_input = nil)
    file_path = File.expand_path("../input_full.txt", __FILE__)
    file = File.open(file_path)
    displayer = Service.new.process(file, 10000)
  end
end

class Service
  attr_reader :counters, :monkeys, :items
  def initialize
    @monkeys = {}
    @i = 0
    @counters = {}
    @item_id = 0
    @items = []
    @divisible = []
  end

  def process(input = nil, round = 20)
    data_to_read(input).each_with_index do |line, _|
      @monkeys[@i] = [] if @monkeys[@i].nil?
      @monkeys[@i] << line.strip unless line == ''
      @i += 1 if line == ''
    end

    @monkeys.each do |idx, monkey_raw|
      @monkeys[idx] = init_monkey(monkey_raw)
    end

    @monkeys.each do |_, monkey|
      @counters[monkey.id] = {}
      monkey.items.each do |item|
        @items << item.id
        @counters[monkey.id][item.id] = 0
      end
    end

    (1 .. round).each do |_|
      @monkeys.each do |_, monkey|
        monkey.items.each do |item|
          item.lvl = monkey.operation.call(item.lvl)
          item.lvl = item.lvl%@divisible.inject(&:*)
          id = item.lvl%monkey.divisible == 0 ? monkey.monkey_index_true : monkey.monkey_index_false
          @monkeys[id].items.push(item)
          monkey.items = monkey.items.drop(1)
          @counters[monkey.id] = {} if @counters[monkey.id].empty?
          @counters[monkey.id][item.id] = 0 if @counters[monkey.id][item.id].nil?
          @counters[monkey.id][item.id]= @counters[monkey.id][item.id] + 1
        end
      end
    end

    cummul = []
    (0..@monkeys.size-1).each do |index|
      cummul << [@counters[index].values.sum, index]
    end

    pp debug_count
    a, b = cummul.sort.reverse[0..1].map(&:first)
    pp "1:#{a} // 2:#{b}"
    pp a*b
  end

  def debug_count
    (0..@monkeys.size-1).each do |index|
      pp "Monkey #{index} inspected items #{@counters[index].values.sum} times."
    end
    nil
  end

  def debug_monkeys
    @monkeys.each do|idx, monkey|
      pp "Monkey #{monkey.id} : #{monkey.items.map{|v| v[:lvl]}.join(' ')} "
    end
    nil
  end

  def init_monkey(monkey_raw)
    id = monkey_raw[0].split(' ').last.to_i
    items = monkey_raw[1].sub('Starting items: ', '').strip.split(',').map(&:to_i)
    items = items.map do |lvl|
      @item_id = @item_id + 1
      OpenStruct.new({ id: @item_id.dup, lvl: lvl })
    end

    divisible = monkey_raw[3].split(' ').last.to_i
    @divisible << divisible
    monkey_index_true = monkey_raw[4].split(' ').last.to_i
    monkey_index_false = monkey_raw[5].split(' ').last.to_i
    sym = monkey_raw[2].split('').select { |v| ['-', '+', '*'].include? v }.first
    value = monkey_raw[2].split(' ').last.to_i
    operation = ->(item) { item.send(sym.to_sym, value == 0 ? item : value) }
    OpenStruct.new({
                     id: id,
                     items: items,
                     operation: operation,
                     divisible: divisible,
                     monkey_index_true: monkey_index_true,
                     monkey_index_false: monkey_index_false
                   })
  end

  def data_to_read(input)
    return input.readlines.map(&:chomp) if input

    @input.map(&:chomp)
  end
end

App.new.day111(file:'_full', round:20)
App.new.day111(file:'', round:10000)
#App.new.day112


