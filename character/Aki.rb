class Aki < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art

  def initialize
    @name = 'Aki Koriyama'
    @health = 1
    @humanity = 1
    @science = 1
    @sport = 1
    @art = 1
  end

  def eval(chara)
    (sigmoid(chara.health - @health) + sigmoid(chara.science - @science)) / 2
  end
end
