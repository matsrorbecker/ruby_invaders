require_relative 'alien_bullet.rb'
require_relative 'game_object.rb'

class Alien < GameObject
  attr_reader :secret_number
  TICKS_PER_SPEED = 180
  TICKS_PER_FRAME = 30
  WIDTH = 39
  HEIGHT = 24
  INITIAL_MOVEMENT = WIDTH + 10
  MAX_MOVEMENT = INITIAL_MOVEMENT * 2  
  INITIAL_SPEED = ACCELERATION = 0.2
  Y_SPEED = 10
  TRIGGER_HAPPINESS = 1500 
    
  def initialize(window, x, y, type)
    super(x, y, WIDTH, HEIGHT)
    @window = window
    @type = type
    @frame = 0
    @x = x
    @y = y
    @speed = INITIAL_SPEED
    @movement = INITIAL_MOVEMENT
    @ticks = 0
    @secret_number = rand(TRIGGER_HAPPINESS)
  end
  
  def update
    @x += @speed
    @movement += @speed
    
    # Time to change direction?
    if @movement.abs > MAX_MOVEMENT
      @speed *= -1
      @movement = 0
      @y += Y_SPEED
    end
    
    @ticks += 1
    
    # Time to change frame?
    if @ticks % TICKS_PER_FRAME == 0
      if @frame == 0
        @frame = 1
      else
        @frame = 0
      end
    end
    
    # Time to gear up?
    if @ticks > TICKS_PER_SPEED
      if @speed > 0
        @speed += ACCELERATION
      else
        @speed -= ACCELERATION
      end
      @ticks = 0
    end
  end

  def fire
    @window.alien_bullets.push AlienBullet.new(@window, @x + 15, @y + 12)
  end
    
  def draw
    SpriteManager.instance.draw(@type, @x, @y, 1, @frame)
  end
end
