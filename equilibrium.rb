require "puyoform.rb"

class Equilibrium < Array

  def initialize(game)
    @players = Hash.new
    game.teams.each { |team|
      puts team.size
      team.each { |player|
        @players[player] = Array.new
      }
    }
  end

  def get_color(player,i,difficulty)
    #puts "equilibrium "+self.to_s
    j = 0
    if @players[player].first != nil
      j = @players[player].shift
    elsif self[i] != nil
      j = self[i]
    else
      j = rand(difficulty)
      self.push(j)
    end
    player.nb_puyos += 1
    return j
  end   
  
  def get_color_different(player,i,difficulty,color)
    #puts "equilibrium "+self.to_s
    j = 0
    bool = false
    @players[player].each { |colori|
      if colori !=  color && !bool
        j = @players[player].delete(colori)
        bool = true
      end
    }
    if !bool
      k = i
      while self[k] != nil && !bool
        if self[k] != color
          j = self[k]
          bool = true
        else
          @players[player].push(self[k])
          k += 1
        end
      end
      if !bool
        colori = rand(difficulty)
        while colori == color
          colori = rand(difficulty)
        end
        j = colori
        self.push(j)
      end
    end 
    player.nb_puyos += 1
    return j  
  end

end