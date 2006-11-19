class Team < Array
  
  @@ids=0
  
  def initialize()
    @@ids+=1
    @id=@@ids
  end
  
  def id
    return @id
  end
  
  def game= (game)
    @game = game
  end
  
  def add_player(player)
    self.push(player)
    player.team = player
  end
  
  def start 
    self.each { |player|
      player.start
    }
  end
  
end