require_relative 'game_object.rb'

class Bunker < GameObject
  WIDTH = 66
  HEIGHT = 48
  Y_POS = 528
  
  def initialize(window, x)
    super(x, Y_POS, WIDTH, HEIGHT)
  end
  
  def draw
    SpriteManager.instance.draw(:bunker, @x, @y, 1)
  end
end
