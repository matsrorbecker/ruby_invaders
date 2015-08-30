require_relative 'game_object.rb'

class AlienBullet < GameObject
  SPEED = 10
  WIDTH = 9
  HEIGHT = 18
    
  def initialize(window, x, y, bullet_type = :cannon)
    super(x, y, WIDTH, HEIGHT)
  end
  
  def update
    @y += SPEED
  end
  
  def draw
    SpriteManager.instance.draw(:alien_bullet, @x, @y, 1)
  end
end
