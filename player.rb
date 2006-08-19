require "puyochart.rb"
require "puyo.rb"

class Player
   
  @@ids=0
    
  def initialize(nb,character,velocity,difficulty,render_engine,control)
    @@ids+=1
    @id=@@ids
    @puyo_chart = PuyoChart.new()
    @current_puyos = Array.new()
    @next_puyos = Array.new()
    @ojama_puyos = 0
    @had_chained = Array.new
    @had_ojamajed = false
    @can_move = false
    @nb = nb
    @character = character
    @velocity = velocity
    @difficulty = difficulty
    @score = 0
    @render_engine = render_engine
    @control = control
    @control.player = self
    @puyos_exploded = Array.new
    @nb_puyos = 0
  end
  
  def id
    return @id
  end
   
  def puyo_chart
    return @puyo_chart   
  end
  
  def current_puyos
    return @current_puyos  
  end
  
  def set_current_puyos(current_puyos)
    @current_puyos = current_puyos
  end
  
  def game
    return @game
  end
  
  def game= (game)
    @game = game
  end
  
  def ojama_puyos= (nb)
    @ojama_puyos += nb
  end
  
  def rotation
    return @rotation
  end
  
  def nb
    return @nb
  end
  
  def character
    return @character
  end
  
  def velocity
    return @velocity
  end
  
  def score
    return @score
  end
  
  def team
    return @team
  end
  
  def team= (team)
    @team = team
  end
  
  def nb_puyos
    return @nb_puyos
  end
  
  def nb_puyos= (nb_puyos)
    @nb_puyos = nb_puyos
  end
  
  def batankyu?
    return @puyo_chart.batankyu?
  end
  
  def start
    puts nb.to_s+" #start#"
    @next_puyos.push(@character.dropset.next().instanciate(self,@game.equilibrium,@difficulty))
    @next_puyos.push(@character.dropset.next().instanciate(self,@game.equilibrium,@difficulty))
    swich_puyos()
    @can_move = true
    @control.listen
  end
  
  def swich_puyos()
    puts "@"+nb.to_s+" #switch puyos#"
    @can_move = false
    if !@had_chained.empty?
      puts "@"+nb.to_s+" a chainé, gère les puyos à envoyer"
      nb_puyos_to_send = 0
      @had_chained.each_index { |i|
        nb_puyos_to_send += @had_chained[i] * i+1
      }
      if nb_puyos_to_send > @ojama_puyos
        puts "@"+nb.to_s+" envoit aux ennemis "+(nb_puyos_to_send - @ojama_puyos).to_s+" puyos"
        @game.send_puyos(self,nb_puyos_to_send - @ojama_puyos)
      else
        @ojama_puyos -= nb_puyos_to_send
      end
    end
    if @had_chained.empty? && @ojama_puyos != 0 && !@had_ojamajed
      puts "@"+nb.to_s+" subit une chute d'ojama puyos!"
     # time = Time.now+0.1
      old_current_puyos = @current_puyos
#      @current_puyos.each { |puyo|
#        @render_engine.delete_puyo_current(self,puyo,time)  
#      }
      if @ojama_puyos >= 30
        @ojama_puyos -= 30
        @current_puyos = ojamapuyos_fall(30)
      else
        @current_puyos = ojamapuyos_fall(@ojama_puyos)
        @ojama_puyos = 0
      end           
#      @current_puyos.each { |puyo|
#        @render_engine.add_puyo_current(self,puyo,time)  
#      }
      @had_ojamajed = true
      #@render_engine.down(self,@current_puyos,velocity/10)
      #@render_engine.down(self,velocity/10)
      @render_engine.ojamafall(self,old_current_puyos,@current_puyos,@velocity/10)
    else
#      time = Time.now+0.1
      old_current_puyos = @current_puyos    
#      @current_puyos.each { |puyo|
#        @render_engine.delete_puyo_current(self,puyo,time)  
#      }
      @current_puyos = @next_puyos.shift
#      @current_puyos.each { |puyo|
#        @render_engine.add_puyo_current(self,puyo,time)  
#      }
      puts "@"+nb.to_s+" a une nouvelle forme qui tombe : "+@current_puyos.to_s
      @current_puyos.each { |puyo|
        if puyo.row == 2 && puyo.column == 6
          @rotation = puyo
        end
      }
      @next_puyos.push(@character.dropset.next().instanciate(self,@game.equilibrium,@difficulty))
      @had_ojamajed = false
      @had_chained.clear
      @can_move = true
      #@render_engine.down(self,@current_puyos,velocity)
      #puts "va downer"
      @render_engine.switch(self,old_current_puyos,@current_puyos,@velocity)
    end
  end
  
  def ojamapuyos_fall(nb)
    full_columns = nb / 6
    extras_puyos = nb - full_columns*6
    falling_puyos = Array.new
    (1..full_columns).map { |i|
      (1..6).map { |j|
        puyo = OjamaPuyo.new()
        puyo.set_pos(5-i,j-1)
        falling_puyos.push(puyo)
      }
    }
    if extras_puyos > 0
      (1..extras_puyos).map { |i|
        puyo = OjamaPuyo.new()
        puyo.set_pos(5-full_columns,i-1)
        falling_puyos.push(puyo)
      }
    end  
    return falling_puyos
  end
  
  def chain
    time = Time.now+0.1
    @puyos_exploded = @puyo_chart.get_exploding_puyos()
    #puts "dokkan ?"
    puts "explod "+@puyos_exploded.to_s
    if @puyos_exploded.empty?
      puts "@"+nb.to_s+" ne chaine pas"
      swich_puyos()
    else
      puts "@"+nb.to_s+" chaine!!, les puyos qui vont explosés sont: "+ @puyos_exploded.to_s
      @score += @puyos_exploded.size
      @had_chained.push(@puyos_exploded.size)
      #@render_engine.explod(self,@puyos_exploded,200)
#      time = Time.now+0.1
      @puyos_exploded.each { |puyo|
        @puyo_chart.delete_puyo(puyo)
#        @render_engine.explod(self,puyo,200,time)  
#        @render_engine.delete_puyo_chart(self,puyo,time)
      }
      @render_engine.explod(self,@puyos_exploded)
      #@render_engine.explod(self,@puyos_exploded,200)
    end
  end

  def fall
    puts "@"+nb.to_s+" fait tomber les puyos après explosion s'il y en a"
    puyos_fall = @puyo_chart.get_falling_puyos()
    if !puyos_fall.empty?
#      time = Time.now+0.1
#      @current_puyos.each { |puyo|
#        @render_engine.delete_puyo_current(self,puyo,time)  
#      }
      old_current_puyos = @current_puyos   
      @current_puyos=puyos_fall
      @current_puyos.each { |puyo|       
        @puyo_chart.delete_puyo(puyo)
#        @render_engine.delete_puyo_chart(self,puyo,time)
#        @render_engine.add_puyo_current(self,puyo,time)  
      }
      #@render_engine.down(self,@current_puyos,@velocity/2)
#      @render_engine.down(self,@velocity/2)
      @render_engine.fall(self,old_current_puyos,@current_puyos,@velocity/2)
    else
      swich_puyos()
    end
    
  end

  def updown_collision()
    @can_move =false
    puts "@"+nb.to_s+" gère une collision haut-bas : "+ @current_puyos.to_s
    new_current_puyos = Array.new
    puyos_to_add = Array.new
#    time = Time.now+0.1
    @current_puyos.sort{|a,b| b.row <=> a.row}.each { |puyo|
      if puyo.row == 18 || @puyo_chart.chart[puyo.row+1][puyo.column] != nil
        @puyo_chart.add_puyo(puyo.row,puyo.column,puyo)
        puyos_to_add.push(puyo)
        #@render_engine.add_puyo_chart(self,puyo,time)
      else
        new_current_puyos.push(puyo)
      end
    }
#    @current_puyos.each { |puyo|
#        @render_engine.delete_puyo_current(self,puyo,time)  
#    }
    @render_engine.update(self,puyos_to_add,@current_puyos)
    @current_puyos = new_current_puyos
    if new_current_puyos.empty?
      chain()
    else
      puts "@"+nb.to_s+" tout n'est pas tombé, fait tombé le reste"
#      @current_puyos.each { |puyo|
#        @render_engine.add_puyo_current(self,puyo,time)  
#      }
      #@render_engine.down(self,@current_puyos,@velocity/10)
#      @render_engine.down(self,@velocity/10)
      @render_engine.continue(self,@current_puyos,@velocity/10)
    end
  end

  def right_pressed ()
    if @can_move
      puts "@"+nb.to_s+" bouge à droite la forme : "+ @current_puyos.to_s
      @render_engine.move_right(self,@velocity/2)
    end
  end
  
  def left_pressed ()
    if @can_move
      puts "@"+nb.to_s+" bouge à gauche la forme : "+ @current_puyos.to_s
      @render_engine.move_left(self,@velocity/2)
    end
  end
  
  def down_pressed ()
    if @can_move
      @render_engine.move_down(self,@velocity/5)
    end
  end
  
  def a_pressed () 
    if @can_move
      if @current_puyos.size == 4
        @render_engine.change_color(self,(@current_puyo.first.color +1) % difficulty)
      else
        @render_engine.rotate_clockwise(self,@velocity/2,@rotation)
      end
    end
  end
  
  def b_pressed ()
    if @can_move
      if @current_puyos.size == 4
        @render_engine.change_color(self,(@current_puyo.first.color -1) % difficulty)
      else
        @render_engine.rotate_anticlockwise(self,@velocity/2,@rotation)
      end
    end
  end
  
end