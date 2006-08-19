class Listener

  def initialize(game,render_engine)
    @game = game 
    @render_engine = render_engine 
  end

  def updown_collision(player)
    player.updown_collision()
  end
  
  def right_left_collision(player)
  end
  
  def explosion_completed(player)
    player.fall()
  end
end