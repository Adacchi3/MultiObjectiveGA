class Rizumi < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art

  def initialize
    @name = 'Rizumi Kyono'
    @health = 10
    @humanity = 1
    @science = 1
    @sport = 1
    @art = 10
  end

  def eval(chara)
    (sigmoid(chara.health - @health) + sigmoid(chara.art - @art)) / 2
  end
end
