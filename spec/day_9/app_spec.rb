require_relative '../../day_9/app.rb'
describe App do
  describe 'map' do
    it 'return the correct map with dot as value' do
      m = Map.new(['R 1']).process
      expect(m.coords).to eql([{x:1,y:0}])
    end
    it 'return the correct map with dot as value' do
      m = Map.new(['R 2']).process
      expect(m.coords).to eql([{x:1,y:0},{x:1,y:0}])
    end
  end
end