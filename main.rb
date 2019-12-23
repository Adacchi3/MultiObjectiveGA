Dir[File.expand_path('character', __dir__) << '/*.rb'].each do |file|
  require file
end

@GENES_LENGTH = 30
@PLAYER_LIST_SIZE = 100
@ELITE_PLAYER_SIZE = 20
@DROP_GENES_SIZE = 80
@INDIVIDUAL_MUTATION = 10
@GENES_MUTATION = 10
@GENERATION_SIZE = 40
@MAX_ACTION_TYPES = 5

def createGenes
  Array.new(@GENES_LENGTH) { rand(@MAX_ACTION_TYPES) }
end

def selecteElites(playerList)
  # sortedList = playerList.sort { |a, b| (a.evalValue <=> b.evalValue) }
  sortedList = fastNonDominatedSort(playerList)
  # elites = sortedList.drop(@DROP_GENES_SIZE)
  elites = sortedList.slice(0..@ELITE_PLAYER_SIZE)
  elites
end

# TODO: fast non-dominated sortのアルゴリズムで用いられていた1文字変数をそのまま使っているので，
# 　　　　コードが読みづらくなっている．直そうにも，論文読まないと正式名称がわからない．．．
def fastNonDominatedSort(playerList)
  rank = Array.new(@PLAYER_LIST_SIZE) { 0 }
  n = Array.new(@PLAYER_LIST_SIZE) { 0 }
  s = Array.new(@PLAYER_LIST_SIZE) { 0 }
  f = []
  i = 0
  (0..@PLAYER_LIST_SIZE - 1).each do |playerNum|
    player = playerList[playerNum]
    (0..@PLAYER_LIST_SIZE - 1).each do |rivalNum|
      rival = playerList[rivalNum]
      if player.dominate(rival)
        s[playerNum] = [] if s[playerNum] == 0
        s[playerNum] << rival
      elsif rival.dominate(player)
        n[playerNum] += 1
      end
    end
    if n[playerNum] == 0
      rank[playerNum] = 1
      f[i] = [] if f[i].nil?
      f[i] << player
    end
  end
  while f[i].size > 0
    q = []
    f[i].each do |player|
      playerNum = playerList.index(player)
      if s[playerNum] != 0
        s[playerNum].each do |rival|
          rivalNum = playerList.index(rival)
          n[rivalNum] -= 1
          if n[rivalNum] == 0
            rank[rivalNum] = i + 1
            q << rival
          end
        end
      end
    end
    i += 1
    f[i] = q
  end
  eliteList = []
  f.reverse_each do |nonDominatedPlayerList|
    nonDominatedPlayerList.each do |player|
      eliteList.push(player)
    end
  end
  eliteList
  # f.each do |nonDominatedPlayerList|
  #   # puts nonDominatedPlayerList.size
  #   nonDominatedPlayerList.each do |player|
  #     playerList.delete(player)
  #   end
  # end
  # f.reverse_each do |nonDominatedPlayerList|
  #   nonDominatedPlayerList.each do |player|
  #     playerList.push(player)
  #   end
  # end
  # playerList
end

def crossover(player1, player2)
  crossoverPlayerList = []
  cross1 = rand(@GENES_LENGTH)
  cross2 = rand(cross1..@GENES_LENGTH - 1)
  genes1 = player1.genes.slice(0..cross1).concat(player2.genes.slice(cross1 + 1..cross2)).concat(player1.genes.slice(cross2 + 1..@GENES_LENGTH))
  genes2 = player2.genes.slice(0..cross1).concat(player1.genes.slice(cross1 + 1..cross2)).concat(player2.genes.slice(cross2 + 1..@GENES_LENGTH))
  progeny1 = Player.new
  progeny2 = Player.new
  progeny1.loadGenes(genes1)
  progeny2.loadGenes(genes2)
  crossoverPlayerList << progeny1
  crossoverPlayerList << progeny2
  crossoverPlayerList
end

def createNextPlayerList(currentPlayerList, elitePlayerList, progenyPlayerList)
  currentPlayerList.sort { |a, b| (a.evalValue <=> b.evalValue) }
  # nextPlayerList = nextPlayerList.drop(elitePlayerList.size + progenyPlayerList.size)
  nextPlayerList = []
  nextPlayerList.concat(elitePlayerList)
  nextPlayerList.concat(progenyPlayerList)
  nextPlayerList.each do |player|
    currentPlayerList.delete(player)
  end
  drop_size = @PLAYER_LIST_SIZE - nextPlayerList.size
  nextPlayerList.concat(currentPlayerList.slice(0..drop_size-1))
end

def mutation(playerList)
  mutatedPlayerList = []
  playerList.each do |player|
    if @INDIVIDUAL_MUTATION > rand(100)
      genes = []
      player.genes.each do |gene|
        genes << if @GENES_MUTATION > rand(100)
                   rand(@MAX_ACTION_TYPES)
                 else
                   gene
                 end
      end
      mutatedPlayer = Player.new
      mutatedPlayer.loadGenes(genes)
      mutatedPlayerList << mutatedPlayer
    else
      mutatedPlayerList << player
    end
  end
  mutatedPlayerList
end

if $PROGRAM_NAME == __FILE__
  charaList = []
  charaList << Aki.new
  charaList << Rizumi.new
  charaList << Yuu.new
  charaList << Tsugumi.new

  playerList = []
  elitePlayerList = []
  (1..@PLAYER_LIST_SIZE).each do |_pNum|
    player = Player.new
    genes = createGenes
    player.loadGenes(genes)
    playerList << player
  end

  (1..@GENERATION_SIZE).each do |generationCount|
    playerList.each do |player|
      player.doActions
      player.favoritedValues = []
      charaList.each do |chara|
        player.favoritedValues << chara.eval(player)
      end
      player.evalValue = player.favoritedValues.sum / player.favoritedValues.size
      # player.evalValue = player.favoritedValues.max
    end
    elitePlayerList = selecteElites(playerList)
    progenyPlayerList = []
    (1..@ELITE_PLAYER_SIZE - 1).each do |pNum|
      progenyPlayerList.concat(crossover(elitePlayerList[pNum - 1], elitePlayerList[pNum]))
    end
    nextPlayerList = createNextPlayerList(playerList, elitePlayerList, progenyPlayerList)
    nextPlayerList = mutation(nextPlayerList)

    evalValues = []
    playerList.each do |player|
      evalValues << player.evalValue
    end

    # puts "---第#{generationCount}世代の結果---"
    # puts "AVG: #{evalValues.inject(0.0) { |r, i| r += i } / evalValues.size}"
    # puts "Max: #{evalValues.max}"
    # puts "Min: #{evalValues.min}"
    # puts ''
    puts "#{generationCount}, #{evalValues.inject(0.0) { |r, i| r += i } / evalValues.size}, #{evalValues.max}"

    playerList = nextPlayerList
  end
  # bestPlayer = elitePlayerList[19]
  # puts "最も優れたプレイヤーの行動履歴は#{bestPlayer.genes}"
  # (0..charaList.size - 1).each do |charaNum|
  #   puts "#{charaList[charaNum].name}の好感度： #{bestPlayer.favoritedValues[charaNum]}"
  # end
  charaName = "playerName, "
  (0..charaList.size - 1).each do |charaNum|
    charaName += "#{charaList[charaNum].name}, "
  end
  puts charaName
  elitePlayerList.each do |player|
    result = "#{player.name}, "
    (0..charaList.size - 1).each do |charaNum|
      result += "#{player.favoritedValues[charaNum]}, "
    end
    puts result
  end
end
