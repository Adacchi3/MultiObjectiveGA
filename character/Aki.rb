class Aki < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art

  def initialize
    @name = 'Aki Koriyama'
    @health = 10
    @humanity = 1
    @science = 10
    @sport = 1
    @art = 1
  end

  def eval(chara)
    sigmoid(chara.science.to_f/chara.genes.size)
  end
end
