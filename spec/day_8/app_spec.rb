require_relative '../../day_8/app.rb'
describe App do
  describe "#tree_1" do
    it "returns good result" do
      app = App.new
      expect(app.tree_1).to eql(1825)
    end
  end
end