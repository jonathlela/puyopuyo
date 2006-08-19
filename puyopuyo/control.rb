class Control 

  def initialize (left,right,down,a_button,b_button)
    @left = left
    @right = right
    @down = down
    @a_button = a_button
    @b_button = b_button 
  end

  def player
    return @player
  end
  
  def player= (player)
    @player = player
  end
  
  def right_pressed?()
  end

  def left_pressed?()
  end

  def rdown_pressed?()
  end

  def a_pressed?()
  end
  
  def b_pressed?()
  end
  
  def listen
    control = Thread.new() {
      #while !@player.batankyu? do
      while true do
        if right_pressed?()
          @player.right_pressed
        elsif left_pressed?()
          @player.left_pressed
        elsif down_pressed?()
          @player.down_pressed
        elsif a_pressed?()
          @player.a_pressed
       elsif b_pressed?()
          @player.b_pressed
        end
        sleep(0.050)
      end
    }
  end

end