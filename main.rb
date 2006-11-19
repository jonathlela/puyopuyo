require "character.rb"
require "control.rb"
require "player.rb"
require "team.rb"
#require "glengine.rb"
require "graphiclocalsocket.rb"
require "graphicengine.rb"
require "game.rb"
require "sdlcontrols.rb"





BASE_DIFFCULTY = 2
BASE_VELOCITY = 500

amity = Character.new("amity")
raffine = Character.new("raffine")

control1 = SDLControls.new(SDL::Key::LEFT,SDL::Key::RIGHT,SDL::Key::DOWN,SDL::Key::B,SDL::Key::N)

control2 = SDLControls.new(SDL::Key::Q,SDL::Key::D,SDL::Key::S,SDL::Key::A,SDL::Key::Z)

graphic_engine = GraphicLocalSocket.new('localhost',23000)
render_engine = RenderEngine.new(graphic_engine,nil,nil)
#render_engine = GLengine.new()

player1 = Player.new(0,amity,BASE_VELOCITY,BASE_DIFFCULTY,render_engine,control1)

player2 = Player.new(1,raffine,BASE_VELOCITY,BASE_DIFFCULTY,render_engine,control2)

team1 = Team.new()
team1.add_player(player1)

team2 = Team.new()
team2.add_player(player2)

teams = Array.new()
teams << team1 << team2

game = Game.new(teams,render_engine)

render_engine.game= game

game.start()

while true do
  render_engine.render()
  sleep(0.001)
end

