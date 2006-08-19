require 'sdl'
require "control2.rb"

class SDLControls2 < Control2
  
  def lighting_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@lighting)
  end

  def frame_limit_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@frame_limit)
  end
end