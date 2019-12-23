class Tsugumi < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art

  def initialize
    @name = 'Tsugumi Godo'
    @health = 1
    @humanity = 10
    @science = 1
    @sport = 1
    @art = 1
  end

  def eval(chara)
    sigmoid(chara.humanity.to_f/chara.genes.size)
  end
end
