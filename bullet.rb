require_relative 'game_object.rb'

class Bullet < GameObject
  SPEED = 20
  WIDTH = 3
  HEIGHT = 18
    
  def initialize(window, x, y)
    super(x, y, WIDTH, HEIGHT) 
  end

  def update
    @y -= SPEED
  end
  
  def draw
    SpriteManager.instance.draw(:bullet, @x, @y, 1)
  end
end
