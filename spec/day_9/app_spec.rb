require_relative '../../day_9/app.rb'
describe App do
  describe 'map' do
    it 'initial state' do
      m = Map.new(['R 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}])
    end
    # RU
    it 'diagonal_up_right no moove' do
      m = Map.new(['R 1', 'U 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}])
    end
    # RD
    it 'diagonal_up_right no moove' do
      m = Map.new(['R 1', 'D 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}])
    end
    # LU
    it 'diagonal_up_right no moove' do
      m = Map.new(['L 1', 'U 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}])
    end
    # LD
    it 'diagonal_up_right no moove' do
      m = Map.new(['L 1', 'D 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}])
    end

    # RUR
    it 'right up right -> diag right up ' do
      m = Map.new(['R 1', 'U 1','R 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>1}])
    end
    # RUU
    it 'righ up up -> diag right up ' do
      m = Map.new(['R 1', 'U 1','U 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>1}])
    end

    # RDR
    it 'right down right -> diag right down ' do
      m = Map.new(['R 1', 'D 1','R 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>-1}])
    end
    # RDD
    it 'righ down down -> diag righ down' do
      m = Map.new(['R 1', 'D 1', 'D 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>-1}])
    end
    # LUL
    it 'left up left -> diag left up ' do
      m = Map.new(['L 1', 'U 1','L 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>-1, :y=>1}])
    end
    # LUU
    it 'left up up -> diag left up ' do
      m = Map.new(['L 1', 'U 1','U 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>-1, :y=>1}])
    end
    # LDL
    it 'left down left -> diag left down ' do
      m = Map.new(['L 1', 'D 1','L 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>-1, :y=>-1}])
    end
    # LDD
    it 'left down down -> diag left down' do
      m = Map.new(['L 1', 'D 1', 'D 1']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>-1, :y=>-1}])
    end

    it 'can reach negative value on horizontal' do
      m = Map.new(['R 3', 'L 4']).process
      expect(m.head).to eql({x:-1,y:0})
    end
    it 'can reach negative value on vertical' do
      m = Map.new(['U 3', 'D 4']).process
      expect(m.head).to eql({x:0,y:-1})
    end

    it 'right multiple' do
      m = Map.new(['R 2']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>0}])
    end
    it 'left multiple' do
      m = Map.new(['R 3','L 2']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>1, :y=>0}, {:x=>2, :y=>0}])
    end
    it 'up multiple' do
      m = Map.new(['U 2']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>0, :y=>1}])
    end
    it 'down multiple' do
      m = Map.new(['D 2']).process
      expect(m.coords).to eql([{:x=>0, :y=>0}, {:x=>0, :y=>-1}])
    end

    it'test' do
      input = ["R 4", "U 4", "L 3", "D 1", "R 4", "D 1", "L 5", "R 2"]
      res = %w(10, 20, 30, 41, 42, 43, 34, 24, 33, 43, 32, 22, 12)
      m = Map.new(input).process
      expect(m.coords.size).to eql(13)
    end
  end

  describe 'map2' do
    it'test R2' do
      input = ["R 2"]
      m = Map3.new(input).process
      expect(m.tails[0][:x]).to eq 1
    end

    it'test R3' do
      input = ["R 3"]
      m = Map3.new(input).process
      expect(m.tails[0][:x]).to eq 2
    end

    it'test R4' do
      input = ["R 4"]
      m = Map3.new(input).process
      expect(m.tails[0][:x]).to eq 3
      expect(m.tails[1][:x]).to eq 2
      expect(m.tails[2][:x]).to eq 1
    end

    it'test R4 U1' do
      input = ["R 4", "U 1"]
      m = Map3.new(input).process
      expect(m.tails[0][:x]).to eq 3
      expect(m.tails[0][:y]).to eq 0

      expect(m.head[:x]).to eq 4
      expect(m.head[:y]).to eq 1
    end

    it'test R4 U2' do
      input = ["R 4", "U 2"]
      m = Map3.new(input).process
      expect(m.tails[0][:x]).to eq 4
      expect(m.tails[0][:y]).to eq 1

      expect(m.head[:x]).to eq 4
      expect(m.head[:y]).to eq 2
    end

    it'test R2 U2' do
      input = ["R 2", "U 2"]
      m = Map3.new(input).process
      expect(m.head).to eq({x:2, y:2})
      expect(m.tails[0]).to eq({x:2, y:1})
      expect(m.tails[1]).to eq({x:1, y:1})
    end

    it'test R10 U10' do
      data = "R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20"
      input = data.split("\n")
      m = Map3.new(input).process
      pp '--------------------------'
      pp m.tails
      pp m.coords.size
      pp '--------------------------'
    end
  end
end