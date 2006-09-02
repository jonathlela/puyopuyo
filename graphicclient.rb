require 'socket'
require 'glengine'
require 'client/graphic/Puyo3D'
require 'glplayer'
require 'puyo3dform'
require 'scenetree.rb'

class GraphicClient
  DOMAIN="localhost"
  PORT=23000
  @@id=0
  def initialize(engine)
    @engine=engine
    @socket = UDPSocket::new
    @socket.connect(DOMAIN,PORT)
    @socket.send( "initialized",0, DOMAIN, PORT )
  end
  def listen
     Thread.new() {
      while true do
        reply, from = @socket.recvfrom(100000, 0 )
        puts reply
        words = reply.split
        case words[0]
          when "add_puyo_current"
            puyos=Array.new
            i=3
            while (words[i]!="}")
              puyos.push(Puyo3D.new(words[i].to_i,words[i+1].to_i,words[i+2].to_i,words[i+3].to_i))
              i+=4
            end
            @engine.add_puyo_current(words[1].to_i,puyos)
            #p=Puyo3D.new(words[2].to_i,words[3].to_i,words[4].to_i,words[5].to_i)
            #@engine.add_puyo_current(words[1].to_i,p)
          when "move_puyo_from_current_to_chart"
            puyos_id=Array.new
            i=3
            while (words[i]!="}")
              puyos_id.push(words[i].to_i)
              i+=1
            end
            @engine.move_puyo_from_current_to_chart(words[1].to_i,puyos_id)
          when "move_puyo_from_chart_to_current"
            puyos_id=Array.new
            i=3
            while (words[i]!="}")
              puyos_id.push(words[i].to_i)
              i+=1
            end
            @engine.move_puyo_from_chart_to_current(words[1].to_i,puyos_id)           
          when "delete_puyo_current"
            @engine.del_puyo_current(words[1].to_i,words[2].to_i)
          when "delete_puyo_chart"
            @engine.del_puyo_chart(words[1].to_i,words[2].to_i)
          when "down"
            @engine.down(words[1].to_i,words[2].to_i)
          when "add_puyo_chart"
            p=Puyo3D.new(words[2].to_i,words[3].to_i,words[4].to_i,words[5].to_i)
            @engine.add_puyo_chart(words[1].to_i,p)
          when "explod"
            puyos_id=Array.new
            i=3
            while (words[i]!="}")
              puyos_id.push(words[i].to_i)
              i+=1
            end
            puts "time to explod: "+words[i+1]
            @engine.explod(words[1].to_i,puyos_id,words[i+1])  
#          when "explod"
#            @engine.explod(words[1].to_i,words[2].to_i,words[3].to_i)
        end
      end
    }
  end
  def updown_collision(player,puyos)
    message="updowncollision "+player.to_s
    puyos.each { |puyo3d|
#       v=puyo.get_world_position()
#       x=v.x+2.5
#       y=12.5-v.y
      v=puyo3d.get_stage_position()
      message << " "+puyo3d.id.to_s+" "+v.y.to_i.to_s+" "+v.x.to_i.to_s
    }
    puts message
    @socket.send(message,0,DOMAIN,PORT) 
  end
  def explosion_completed(player)
    message="explosion_completed "+player.to_s
    puts message
    @socket.send(message,0,DOMAIN,PORT) 
  end
end
