require_relative 'game_object.rb'

class Cannon < GameObject
  SPEED = 5
  Y_POS = 600
  WIDTH = 39
  HEIGHT = 24
    
  def initialize(window)
    super((window.width - WIDTH) / 2, Y_POS, WIDTH, HEIGHT)
    @max_x = window.width - WIDTH * 2
    @min_x = WIDTH
  end
  
  def move_right
    @x += SPEED
    if @x > @max_x
      @x = @max_x
    end
  end
  
  def move_left
    @x -= SPEED
    if @x < @min_x
      @x = @min_x
    end
  end
  
  def draw
    SpriteManager.instance.draw(:cannon, @x, @y, 1)
  end
end
