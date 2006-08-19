require "team.rb"
require "renderengine.rb"
require "listener.rb"
require "equilibrium.rb"

class Game

  attr_reader :teams, :listener
  def initialize(teams,render_engine)
    @teams = teams
    @teams.each { |team|
      team.each { |player|
        player.game = self
      }
    }
    @render_engine = render_engine
    @listener = Listener.new(self,render_engine)
    @equilibrium = Equilibrium.new(self) 
  end
  
  def equilibrium
    return @equilibrium
  end
  
  def start 
    @teams.each { |team|
      team.start
    }
  end
  
  def send_puyos(player,nbpuyos)
    opponent_teams = @teams - [player.team]
    team_remainder = nbpuyos.remainder(2)#opponent_teams.size)
    opponent_teams.each { |team|
      puyos_by_team = nbpuyos / 2#opponent_teams.size
      if team_remainder > 0
        puyos_by_team += 1
        team_remainder -= 1
      end
      player_remainder = puyos_by_team.remainder(2)#team.size)
      team.each { |opponent_player|
        puyos_by_player = nbpuyos / 2#team.size
        if player_remainder > 0
          puyos_by_player += 1
          player_remainder -= 1
        end
        opponent_player.ojama_puyos = puyos_by_player
      }
    }
  end

end