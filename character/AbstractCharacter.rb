class AbstractCharacter
  @@HEALTH = 0
  @@HUMANITY = 1
  @@SCIENCE = 2
  @@SPORT = 3
  @@ART = 4

  def sigmoid(x)
    1 / (1 + Math.exp(-x))
  end
end
