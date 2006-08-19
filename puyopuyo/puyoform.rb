require "puyo.rb"

class PuyoForm

  def initialize()
    @chart = (1..2).map {Array.new(2)}
  end

  def instanciate(player,equilibrium,difficulty)   
#    color1 = rand(difficulty)
#    color2 = rand(difficulty)
#    color3 = rand(difficulty)
#    while color3 == color1
#      color3 = rand(difficulty)
#    end
    color1 = equilibrium.get_color(player,player.nb_puyos,difficulty)
    puyos = Array.new
    @chart.each_index { |row|
      @chart[row].each_index { |column|
        if @chart[row][column] != nil
          if @chart[row][column] == 1
            puyo = PuyoColor.new(color1)
          elsif @chart[row][column] == 2
            puyo = PuyoColor.new(equilibrium.get_color(player,player.nb_puyos,difficulty))
          else @chart[row][column] == 3
            puyo = PuyoColor.new(equilibrium.get_color_different(player,player.nb_puyos,difficulty,color1))
          end
          puyo.set_pos(row+5,column+2)
          puyos.push(puyo)
        end
      }
    }
    return puyos
  end
  
  def to_s
    @chart.each { |puyo|
      puts puyo
    }
  end

end

class Puyos2 < PuyoForm
  
  def initialize()
    super
    @chart[0][0] = 1
    @chart[1][0] = 2
  end
  
end

class Puyos3 < PuyoForm
  
  def initialize()
    super
    @chart[0][0] = 1
    @chart[1][0] = 1
    @chart[1][1] = 2
  end
  
end

class Puyos2x2 < PuyoForm
  
  def initialize()
    super
    @chart[0][0] = 1
    @chart[0][1] = 3
    @chart[1][0] = 1
    @chart[1][1] = 3
  end
  
end

class Puyos4 < PuyoForm
  
  def initialize()
    super
    @chart[0][0] = 1
    @chart[0][1] = 1
    @chart[1][0] = 1
    @chart[1][1] = 1
  end
  
end