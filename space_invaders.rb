require 'gosu'
require_relative 'cannon.rb'
require_relative 'alien.rb'
require_relative 'bullet.rb'
require_relative 'explosion.rb'
require_relative 'bunker.rb'
require_relative 'sprite_manager.rb'

class SpaceInvaders < Gosu::Window
  attr_accessor :alien_bullets
  WINDOW_WIDTH = 685
  WINDOW_HEIGHT = 800
  ALIEN_ROWS = 5
  ALIENS_PER_ROW = 11
  ALIEN_X_DISTANCE = 10
  ALIEN_Y_DISTANCE = 20
  TOP_ALIEN_Y = 200
  LEFT_BUNKER_X = 111
  
  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    self.caption = "---=== SPACE INVADERS ===---"
    @font = Gosu::Font.new(self, "resources/space_invaders.ttf", 32)
    @cannon = Cannon.new(self)
    @aliens = []
    @bullets = []
    @alien_bullets = []
    @explosions = []
    @bunkers = []
    @score = 0
    @high_score = load_high_score
    create_aliens
    create_bunkers
    load_sprites
    @running = true
  end

  def load_high_score
    f = open("high_score.txt")
    score = f.read.strip
    score.to_i
  end
  
  def create_aliens
    x = Alien::WIDTH * 2
    y = TOP_ALIEN_Y
    alien_type = :alien1
    ALIEN_ROWS.times do |row|
      ALIENS_PER_ROW.times do |i|
        @aliens.push Alien.new(self, x + i * (Alien::WIDTH + ALIEN_X_DISTANCE), y, alien_type)
      end
      y += Alien::HEIGHT + ALIEN_Y_DISTANCE
      x = Alien::WIDTH * 2
      if row == 0
        alien_type = :alien2
      elsif row == 2
        alien_type = :alien3
      end
    end
  end
  
  def create_bunkers
    x = LEFT_BUNKER_X
    4.times do 
      @bunkers.push Bunker.new(self, x)
      x += Bunker::WIDTH * 2
    end 
  end
  
  def load_sprites
    SpriteManager.instance.load_sprite(self, :alien1, "resources/alien1.png", 39, 24)
    SpriteManager.instance.load_sprite(self, :alien2, "resources/alien2.png", 39, 24)
    SpriteManager.instance.load_sprite(self, :alien3, "resources/alien3.png", 39, 24)
    SpriteManager.instance.load_sprite(self, :cannon, "resources/cannon.png", 39, 24)
    SpriteManager.instance.load_sprite(self, :bullet, "resources/bullet.png", 3, 18)
    SpriteManager.instance.load_sprite(self, :alien_bullet, "resources/alien_bullet.png", 9, 18)
    SpriteManager.instance.load_sprite(self, :explosion, "resources/alien_explosion.png", 39, 24)
    SpriteManager.instance.load_sprite(self, :cannon_explosion, "resources/cannon_explosion.png", 45, 24)
    SpriteManager.instance.load_sprite(self, :bunker,"resources/bunker.png", 66, 48)
  end
    
  def update
    if @running
      if button_down?(Gosu::Button::KbRight)
        @cannon.move_right
      end
      
      if button_down?(Gosu::Button::KbLeft)
        @cannon.move_left
      end
      
      alien_to_fire = rand(Alien::TRIGGER_HAPPINESS)
      @aliens.each do |alien|
        alien.update
        if alien_to_fire == alien.secret_number
          alien.fire
        end
      end
      
      @bullets.dup.each do |bullet|
        bullet.update
        @bullets.delete bullet if bullet.y < 0
      end

      @alien_bullets.dup.each do |bullet|
        bullet.update
        @alien_bullets.delete bullet if bullet.y > WINDOW_HEIGHT
      end
      
      @explosions.dup.each do |explosion|
        explosion.update
        @explosions.delete explosion if explosion.finished
      end
      
      check_for_collisions
    end
  end
    
  def check_for_collisions
    @aliens.dup.each do |alien|
      @bullets.dup.each do |bullet|
        if alien.colliding_with?(bullet)
          @explosions.push Explosion.new(self, alien.x, alien.y)
          @aliens.delete alien
          @bullets.delete bullet
          @score += 10
        end
      end
      if @cannon.colliding_with?(alien)
        @explosions.push Explosion.new(self, @cannon.x - 3, @cannon.y, :cannon_explosion)
        @explosions.push Explosion.new(self, alien.x, alien.y)
        @aliens.delete alien
        @running = false
      end  
    end
    
    @bunkers.each do |bunker|
      @bullets.dup.each do |bullet|
        if bunker.colliding_with?(bullet)
          @bullets.delete bullet
        end
      end
      @alien_bullets.dup.each do |bullet|
        if bunker.colliding_with?(bullet)
          @alien_bullets.delete bullet
        end
      end      
    end
    
    @alien_bullets.each do |bullet|
      if @cannon.colliding_with?(bullet)
        @explosions.push Explosion.new(self, @cannon.x - 3, @cannon.y, :cannon_explosion)
        @running = false
      end  
    end
  end
  
  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @cannon.x + 18, @cannon.y)
    end
  end
  
  def draw
    @cannon.draw
    
    @aliens.each do |alien|
      alien.draw
    end
    
    @bullets.each do |bullet|
      bullet.draw
    end
    
    @alien_bullets.each do |bullet|
      bullet.draw
    end
    
    @explosions.each do |explosion|
      explosion.draw
    end
    
    @bunkers.each do |bunker|
      bunker.draw
    end
    
    @font.draw("S C O R E < 1 >     H I - S C O R E     S C O R E < 2 >", 50, 20, 1)
    @font.draw("       " + score_string(@score), 50, 60, 1)
    @font.draw("       " + score_string(@high_score), WINDOW_WIDTH / 3, 60, 1)
  end
  
  # Converts score to a string with 4 numbers and a space between each number
  def score_string(score)
    str = "%04d" % [score]
    str.gsub(/[0-9]/){|number| number += " "}.strip
  end
end

game = SpaceInvaders.new
game.show
