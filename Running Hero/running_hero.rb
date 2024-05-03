require 'gosu'
require_relative 'hero'
require_relative 'enemy'
require_relative 'timing'
require_relative 'camera'

# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class RunningHero < Gosu::Window
    WIDTH = 960
    HEIGHT = 480
    ENEMY_FREQUENCY = 0.01
    ENEMY_RADIUS = 32
    def initialize
        super WIDTH, HEIGHT
        self.caption = "Running Hero"
        @background_image = Gosu::Image.new("images/starry_night.png")
        @hero = Hero.new(self)
        @enemies = []
        @time = Time.new(self)
    end

    def draw
        @background_image.draw(0,0,ZOrder::BACKGROUND)
        # HERO
        @hero.current_hero_image
        @hero.draw
        # ENEMY
        @enemies.each do |enemy|
            enemy.current_enemy_image
            enemy.draw
        end
        #TIME
        @time.draw
    end

    def update
        # ADD SPRITES
        @enemies.push Enemy.new(self) if rand < ENEMY_FREQUENCY and @enemies.count < 4 
        # MOVE SPRITES
        # Hero
        if not @hero.is_hurting
            @hero.stand
            @hero.run(:right) if Gosu::button_down?(Gosu::KbRight)
            @hero.run(:left) if Gosu::button_down?(Gosu::KbLeft)
            @hero.jump if Gosu::button_down?(Gosu::KbUp)
            @hero.handle_jump if @hero.is_jumping
        end
        @hero.stop_hurting if Gosu::milliseconds > @hero.hurt_until
        # COLLISION DETECTION
        @enemies.each do |enemy|
            distance = Gosu.distance(enemy.x, enemy.y, @hero.x, @hero.y)
            if distance <= enemy.radius + @hero.radius
                # When hero hit the enemy
                if @hero.y + @hero.radius < enemy.y + enemy.radius
                    enemy.hurt
                    @hero.jump_from_enemy
                # When enemy hit the hero
                elsif 
                    @hero.hurt
                end
            end
        end
        # When enemies hit each other
        @enemies.each do |enemy|
            enemy.can_hit_other if Gosu::milliseconds > enemy.until_next_hit
        end
        @enemies.each do |enemy_1|
            @enemies.each do |enemy_2|
                if enemy_1 != enemy_2
                    if enemy_1.until_next_hit == 0 and enemy_2.until_next_hit == 0
                        distance = Gosu.distance(enemy_1.x, enemy_1.y, enemy_2.x, enemy_2.y)
                        if distance <= enemy_1.radius + enemy_2.radius
                            enemy_1.hit_other
                            enemy_2.hit_other
                        end
                    end
                end
            end
        end
        # Enemy
        @enemies.each do |enemy|
            if not enemy.is_hurting
                enemy.move
            else
                enemy.stop_hurting if Gosu::milliseconds > enemy.hurt_until
            end
        end
        # CLEANING UP ARRAYS
        @enemies.each do |enemy|
            @enemies.delete enemy if enemy.y - enemy.radius > HEIGHT
        end
        # TIME
        @time.timing
    end

    def button_down(id)
        close if id == Gosu::KbQ
    end
end

RunningHero.new.show