require_relative '../../day_10/app.rb'
describe App do
  describe 'displayer' do
    it 'initial state' do
      displayer = Display.new(input_test).process
      pp displayer.force

      displayer = Display2.new(input_test).process
      pp displayer.display
    end

  end
end

def input_test
  'addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1'.split("\n")
  #file_path = File.expand_path("../../../day_10/input_test.txt", __FILE__)
  #File.open(file_path)
end

def input
end

def input_full
end
'PLGFKAZG'
[" ###..#.....##..####.#..#..##..####..##.",
 ".#..#.#....#..#.#....#.#..#..#....#.#..#",
 ".#..#.#....#....###..##...#..#...#..#...",
 ".###..#....#.##.#....#.#..####..#...#.##",
 ".#....#....#..#.#....#.#..#..#.#....#..#",
 ".#....####..###.#....#..#.#..#.####..###"]