class Player < AbstractCharacter
  attr_reader :name, :health, :humanity, :science, :sport, :art, :genes
  attr_accessor :evalValue, :favoritedValues

  def initialize
    @name = (0...5).map { ('A'..'Z').to_a[rand(26)] }.join
    @health = 1
    @humanity = 1
    @science = 1
    @sport = 1
    @art = 1
    @evalValue = 0
    @isDoActions = true
    @favoritedValues = []
  end

  def loadGenes(genes)
    @genes = genes
  end

  def doActions
    if @isDoActions
      @genes.each do |action|
        act(action)
      end
      @isDoActions = false
    end
  end

  def act(action)
    case action
    when @@HEALTH then
      @health += 1
    when @@HUMANITY then
      @humanity += 1
    when @@SCIENCE then
      @science += 1
    when @@SPORT then
      @sport += 1
    when @@ART then
      @art += 1
    end
  end

  def dominate(player)
    diff = [@favoritedValues, player.favoritedValues].transpose.map { |n| n.inject(:-) }
    diff.any? { |v| v > 0 }
  end
end
