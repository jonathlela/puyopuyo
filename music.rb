require 'sdl'

SDL.init(SDL::INIT_AUDIO)
SDL::Mixer.open#(44100,SDL::Mixer::DEFAULT_FORMAT,2,4096)
#puts SDL::Mixer.spec
song =  SDL::Mixer::Music.load("a.mp3")
SDL::Mixer.play_music(song,-1)
while true do

end