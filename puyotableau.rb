require "puyo.rb"
require "puyochain.rb"

class PuyoTableau 

  def initialize()
    @tableau = Array.new(19).map{Array.new(6)}
    @chains = Array.new
  end
  
  def chains
    return @chains
  end
  
  def tableau
    return @tableau  
  end
  
  def tableau= (tableau)
    @tableau = tableau  
  end
  
  def add_puyo(a,b,puyo)
    @tableau[a][b] = puyo
    puyo.set_pos(a,b)
    if puyo.type == 0
      chain = PuyoChain.new(puyo)
      puyo_connex = get_connex_puyos_from_color(a,b,puyo.color)
      puyo_connex.each { |puyo_co|
        if chain != puyo_co.chain
          old = puyo_co.chain
          puyo_co.chain.each { |puyo_co_plus|
              puyo_co_plus.join(chain)
              chain.push(puyo_co_plus)
          }
          @chains.delete(old)
        end
      }
      @chains.push(chain)
    end
  end
  
  def delete_puyo(puyo)
    if puyo.type == 0
      @chains.delete(puyo.chain)
    end
    @tableau[puyo.row][puyo.column] = nil
  end
  
  def get_connex_puyos_from_color(a,b,color)
    puyo_connex = Array.new
    if a > 0 && a <= 18
      if @tableau[a-1][b] != nil && @tableau[a-1][b].type == 0 && @tableau[a-1][b].color == color
        puyo_connex.push(@tableau[a-1][b])
      end
    end
    if a >= 0 && a < 18
      if @tableau[a+1][b] != nil && @tableau[a+1][b].type == 0 && @tableau[a+1][b].color == color
        puyo_connex.push(@tableau[a+1][b])
      end
    end
    if b > 0 && b <= 5
      if @tableau[a][b-1] != nil && @tableau[a][b-1].type == 0 && @tableau[a][b-1].color == color
        puyo_connex.push(@tableau[a][b-1])
      end
     end
    if b >= 0 && b < 5
      if @tableau[a][b+1] != nil && @tableau[a][b+1].type == 0 && @tableau[a][b+1].color == color
        puyo_connex.push(@tableau[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_color
  
  def get_connex_puyos_from_type(a,b,type)
    puyo_connex = Array.new
    if a > 0 && a <= 18
      if @tableau[a-1][b] != nil && @tableau[a-1][b].type == type
        puyo_connex.push(@tableau[a-1][b])
      end
    end
    if a >= 0 && a < 18
      if @tableau[a+1][b] != nil && @tableau[a+1][b].type == type
        puyo_connex.push(@tableau[a+1][b])
      end
    end
    if b > 0 && b <= 5
      if @tableau[a][b-1] != nil && @tableau[a][b-1].type == type
        puyo_connex.push(@tableau[a][b-1])
      end
     end
    if b >= 0 && b < 5
      if @tableau[a][b+1] != nil && @tableau[a][b+1].type == type
        puyo_connex.push(@tableau[a][b+1])
      end
    end
    return puyo_connex
  end
  private :get_connex_puyos_from_type
   
  def get_exploding_puyos()
    exploding_puyos = Array.new
    @chains.each { |chain|
      if chain.size >= 4
        chain.each { |puyo|
          exploding_puyos.push(puyo)
          puyo_connex =  get_connex_puyos_from_type(puyo.row,puyo.column,OjamaPuyo.new.type)
          puyo_connex.each { |puyo_co|
            exploding_puyos.push(puyo_co)
          }
        }
      end
    }
    return exploding_puyos.uniq
  end
  
  def get_falling_puyos()
    falling_puyos = Array.new
    @tableau.each_index { |i|
      if @tableau[i] != nil && i < 18
        @tableau[i].each_index { |j|
          if @tableau[i][j] != nil && @tableau[i+1][j] == nil
            (0..i).map { |k|
              if @tableau[k][j] != nil
                falling_puyos.push(@tableau[k][j])
                delete_puyo(@tableau[k][j])
              end
            }
          end
        }
      end
    }
    puts "fall"+falling_puyos.to_s
    return falling_puyos
  end
  
  def batankyu?()
    return @tableau[7][2] != nil || @tableau[7][3] != nil 
  end
  
  def to_s
    @tableau.each { |row|
      str = ""
      row.each { |puyo|
        str << puyo.to_s
      }
      puts str  
    }
    puts "fin"
  end
  
end