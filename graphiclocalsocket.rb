require 'socket'
require "graphicsocket.rb"

class GraphicLocalSocket < GraphicSocket

  def initialize(domain,port)
    @socket = UDPSocket.new
    @domain = domain
    @port = port
    @socket.bind(@domain,@port)
    reply = ""
    while reply != "initialized"
      reply, from = @socket.recvfrom(100,0) 
      puts reply
    end
    @domain=from[2]
    @port=from[1]
    puts @domain.to_s+":"+@port.to_s
  end
  
  def game= (game)
    @game = game
    @players = Array.new
    @game.teams.each { |team|
      puts team.size
      team.each { |player|
        @players.push(player)
      }
    }
  end
  
  def get_player_from_id (id) 
    correct_player = nil
    @players.each { |player|
      if player.id.to_f == id.to_f
        correct_player = player
      end
    }
    if correct_player != nil
      return correct_player
    else
      puts "bubu"
    end
  end
  
  def get_puyo_from_id (player,id) 
    correct_puyo = nil
    player.current_puyos.each { |puyo|
      if puyo.id.to_f == id.to_f
        correct_puyo = puyo
      end
    }
    if correct_puyo != nil
      return correct_puyo
    else
      puts "baba"
    end
  end
  
  def render ()
    receive()
  end
  
  def receive()   
    reply, from = @socket.recvfrom(100000, 0 )
    words = reply.split
    case words[0]
      when "updowncollision"
        player = get_player_from_id(words[1].to_i)
        i = 2
        while i < words.size
          puyo = get_puyo_from_id(player,words[i])
          puyo.set_pos(words[i+1].to_i,words[i+2].to_i)
          i += 3
        end
        player.updown_collision()
      when "leftrightcollision"
      when "explosion_completed"
        player = get_player_from_id(words[1])
        player.fall
      end
  end
  
#  def puyo_tableau_to_string(puyos)
#    str = ""
#    puyos.each { |puyo|
#      str << puyo.id.to_s+" "
#    }
#    return str.chop
#  end
#  
#  def current_puyos_to_string(puyos)
#    str = ""
#    puyos.each { |puyo|
#      str << puyo.object_id.to_s+" "+puyo.row.to_s+" "+puyo.column.to_s
#    }
#    return str.chop
#  end

  def puyos_to_string(puyos)
    str = ""
    puyos.each { |puyo|
      str << puyo.object_id.to_s+" "
    }
    return str.chop
  end

  
  def add_puyo_chart(player,puyo,time)
    message = "add_puyo_chart "+player.id.to_s+" "+puyo.id.to_s+" "+puyo.color.to_s+" "+puyo.row.to_s+" "+puyo.column.to_s+" "+time.to_f.to_s
   #puts message
    @socket.send(message,0,@domain,@port) 
  end

  def move_puyo_from_current_to_chart(player,puyos,time)
    message = "move_puyo_from_current_to_chart "+player.id.to_s+" { "
    puyos.each { |puyo| message << puyo.id.to_s+" " }
    message << "} "+time.to_f.to_s
    puts message
    @socket.send(message,0,@domain,@port) 
  end

  def move_puyo_from_chart_to_current(player,puyos,time)
    message = "move_puyo_from_chart_to_current "+player.id.to_s+" { "
    puyos.each { |puyo| message << puyo.id.to_s+" " }
    message << "} "+time.to_f.to_s
    puts message
    @socket.send(message,0,@domain,@port) 
  end

#  
#  def add_puyo_current(player,puyo,time)
#    message = "add_puyo_current "+player.id.to_s+" "+puyo.id.to_s+" "+puyo.color.to_s+" "+puyo.row.to_s+" "+puyo.column.to_s+" "+time.to_f.to_s
#    #puts message
#    @socket.send(message,0,@domain,@port) 
#  end

  def add_puyo_current(player,puyos,time)
    message = "add_puyo_current "+player.id.to_s+" { "
    puyos.each { |puyo| message << puyo.id.to_s+" "+puyo.color.to_s+" "+puyo.row.to_s+" "+puyo.column.to_s+" " }
    message << "} "+time.to_f.to_s
    puts message
    @socket.send(message,0,@domain,@port) 
  end
  
  def delete_puyo_chart(player,puyo,time)
    message = "delete_puyo_chart "+player.id.to_s+" "+puyo.id.to_s+" "+time.to_f.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def delete_puyo_current(player,puyo,time)
    message = "delete_puyo_current "+player.id.to_s+" "+puyo.id.to_s+" "+time.to_f.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def down(player,time_to_fall_one_step)
    message = "down "+player.id.to_s+" "+time_to_fall_one_step.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def move_left(player,time_to_fall_one_step)
    message = "move_left "+player.id.to_s+" "+time_to_fall_one_step.to_s
    puts message
    @socket.send(message,0,@domain,@port) 
  end
  
  def move_right(player,time_to_fall_one_step)
    message = "move_right "+player.id.to_s+" "+time_to_fall_one_step.to_s
    puts message
    @socket.send(message,0,@domain,@port) 
  end
  
  def move_down(player,time_to_fall_one_step)
    message = "move_down "+player.id.to_s+" "+time_to_fall_one_step.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def rotate_clockwise(player,time_to_rotate,puyo_rotation)
    message = "rotate_clockwise "+player.id.to_s+" "+puyo_rotation.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def rotate_anticlockwise(player,time_to_rotate,puyo_rotation)
    message = "rotate_anticlockwise "+player.id.to_s+" "+puyo_rotation.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
  def change_color(player,color)
    message = "change_color "+player.id.to_s+" "+color.to_s
    @socket.send(message,0,@domain,@port) 
  end
  
#  def explod(player,puyo,time_to_explod,time)
#    message = "explod "+player.id.to_s+" "+puyo.id.to_s+" "+time_to_explod.to_s+" "+time.to_f.to_s
#    puts message
#    @socket.send(message,0,@domain,@port)
#  end
  
  def explod(player,puyos,time_to_explod,time)
    message = "explod "+player.id.to_s+" { "
    puyos.each { |puyo| message << puyo.id.to_s+" " }
    message << "} "+time_to_explod.to_s+" "+time.to_f.to_s
    puts message    
    @socket.send(message,0,@domain,@port)
  end

  def highligh(player,puyo)
    message = "higlight "+player.id.to_s+" "+puyo.id.to_s
    @socket.send(message,0,@domain,@port)
  end
  
  def faaaaall(player,time)
    message = "faaaall "+player.id.to_s+" "+time.to_f.to_s
    @socket.send(message,0,@domain,@port)
  end
end