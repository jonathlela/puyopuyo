require 'sdl'
require "control.rb"

class SDLControls < Control
  
  def right_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@right)
  end

  def left_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@left)
  end

  def down_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@down)
  end

  def a_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    SDL::Key.scan
    return SDL::Key.press?(@a_button)
  end
  
  def b_pressed?()
    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        exit
      when SDL::Event2::KeyDown
        exit if event.sym == SDL::Key::ESCAPE
      end
    end
    
    SDL::Key.scan
    return SDL::Key.press?(@b_button)
  end

end