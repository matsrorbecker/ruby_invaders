require 'singleton'

class SpriteManager
  include Singleton
  
  def initialize
    @sprites = {}
  end
  
  def load_sprite(window, key, file, frame_width, frame_height)
    @sprites[key] = Gosu::Image.load_tiles(window, file, frame_width, frame_height, false)
  end
  
  def draw(key, x, y, z, frame = 0)
    @sprites[key][frame].draw(x, y, z)
  end
end
