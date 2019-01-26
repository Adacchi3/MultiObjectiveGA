class Yuu < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art

  def initialize
    @name = 'Yuu Satsuki'
    @health = 7
    @humanity = 7
    @science = 7
    @sport = 7
    @art = 7
  end

  def eval(chara)
    arr = []
    arr << sigmoid(chara.health - @health)
    arr << sigmoid(chara.humanity - @humanity)
    arr << sigmoid(chara.science - @science)
    arr << sigmoid(chara.sport - @sport)
    arr << sigmoid(chara.art - @art)
    arr.sum / arr.size
  end
end
