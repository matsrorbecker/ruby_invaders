class Explosion
  attr_reader :finished
  TICK_LIMIT = 15
  
  def initialize(window, x, y, type = :explosion)
    @type = type
    @x = x
    @y = y
    @finished = false
    @ticks = 0
  end
  
  def update
    @ticks += 1
    if @ticks > TICK_LIMIT
      @finished = true
    end
  end
  
  def draw
    SpriteManager.instance.draw(@type, @x, @y, 2)  
  end
end
