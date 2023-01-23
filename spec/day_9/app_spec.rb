require_relative '../../day_9/app.rb'
describe App do
  describe 'map' do
    it 'initial state' do
      m = Map.new(['R 1']).process
      expect(m.coords).to eql([{x:0,y:0}])
    end
    # R U
    it 'diagonal_up_right no moove' do
      m = Map.new(['R 1', 'U 1']).process
      expect(m.coords).to eql([{x:0,y:0}])
    end

    # R D
    it 'diagonal_up_right no moove' do
      m = Map.new(['R 1', 'D 1']).process
      expect(m.coords).to eql([{x:0,y:0}])
    end

    # L U
    it 'diagonal_up_right no moove' do
      m = Map.new(['L 1', 'U 1']).process
      expect(m.coords).to eql([{x:0,y:0}])
    end

    # L D
    it 'diagonal_up_right no moove' do
      m = Map.new(['L 1', 'D 1']).process
      expect(m.coords).to eql([{x:0,y:0}])
    end

    # R U R
    it 'right up right -> diag up right' do
      m = Map.new(['R 1', 'U 1','R 1']).process
      expect(m.coords).to eql([{x:0,y:0}, {x:1,y:1}])
    end
    # R U U
    it 'righ up up -> diag up right' do
      m = Map.new(['R 1', 'U 1','U 1']).process
      expect(m.coords).to eql([{x:0,y:0}, {x:1,y:1}])
    end

    # R D R
    it 'right down right -> diag down right' do
      m = Map.new(['R 1', 'D 1','R 1']).process
      expect(m.coords).to eql([{x:0,y:0}, {x:-1,y:-1}])
    end
    # R D D
    it 'righ down down -> diag righ down' do
      m = Map.new(['R 1', 'D 1', 'D 1']).process
      expect(m.coords).to eql([{x:0,y:0}, {x:-1,y:-1}])
    end

    it 'do not reach negative value if origin reach' do
      m = Map.new(['R 3', 'L 4']).process
      expect(m.head).to eql({x:0,y:0})
    end
    it 'go in other sens if reach origin' do
      m = Map.new(['R 3', 'L 5']).process
      expect(m.head).to eql({x:1,y:0})
    end

    it 'right multiple' do
      m = Map.new(['R 2']).process
      expect(m.coords).to eql([{x:0,y:0},{x:1, y:0}])
    end
    it 'left multiple' do
      m = Map.new(['L 2']).process
      expect(m.coords).to eql([{x:0,y:0},{x:-1, y:0}])
    end
    it 'up multiple' do
      m = Map.new(['U 2']).process
      expect(m.coords).to eql([{x:0,y:0},{x:0, y:1}])
    end
    it 'down multiple' do
      m = Map.new(['D 2']).process
      expect(m.coords).to eql([{x:0,y:0},{x:0, y:-1}])
    end

    it'test' do
      data = 'R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2'.split("\n")

      m = Map.new(data).process
      expect(m.coords.size).to eql(13)
    end
  end
end