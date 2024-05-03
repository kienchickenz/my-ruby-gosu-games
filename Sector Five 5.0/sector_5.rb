require "gosu"
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'boom'
require_relative 'back_up'
require_relative 'star'

class SectorFive < Gosu::Window
    WIDTH = 1000
    HEIGHT = 700
    ENEMY_FREQUENCY = 0.03
    BOOM_FREQUENCY = ENEMY_FREQUENCY / 2
    STAR_FREQUENCY = 0.1
    def initialize
        super(WIDTH, HEIGHT)
        self.caption = "Sector Five"
        @background_image = Gosu::Image.load_tiles("images/space.png", WIDTH, HEIGHT)
        
        @player = Player.new(self)
        @enemies = []
        @bullets = []
        @explosions = []

        @booms = []
        @boom_it = false

        @back_ups = []
        @need_back_up = false

        @stars = []
    end

    def draw
        # Draw background
        @background_image[0].draw(0, 0, 0)
        # Draw player's ship
        @player.draw
        # Draw every enemy
        @enemies.each do |enemy|
            enemy.draw
        end
        # Draw every bullet
        @bullets.each do |bullet|
            bullet.draw
        end
        # Draw every explosion
        @explosions.each do |explosion|
            explosion.draw
        end
        # Draw every bomb
        @booms.each do |boom|
            boom.draw
        end
        # Draw every ally
        @back_ups.each do |back_up|
            back_up.draw
        end
        # Draw every star
        @stars.each do |star|
            star.draw
        end
    end

    def update
        @player.turn_left if button_down?(Gosu::KbLeft)
        @player.turn_right if button_down?(Gosu::KbRight)

        @player.accelerate if button_down?(Gosu::KbUp)
        @player.move

        # ADD SPRITES
        # Add star
        if rand < STAR_FREQUENCY
            @stars.push Star.new(self)
        end
        # Add backups
        if @need_back_up
            i = 30
            while i < WIDTH    
                @back_ups.push BackUp.new(self, i)  
                i += 45
            end
            @need_back_up = false
        end
        # Add a new bomb
        if @boom_it
            if rand < BOOM_FREQUENCY
                @booms.push Boom.new(self)
            end
        end
        # Add a new enemy
        if rand < ENEMY_FREQUENCY
            @enemies.push Enemy.new(self)
        end

        # MOVE SPRITES
        # Move every enemy
        @enemies.each do |enemy|
            enemy.move
        end
        # Move every bullet
        @bullets.each do |bullet|
            bullet.move
        end
        # Move every ally
        @back_ups.each do |back_up|
            back_up.move
        end

        # COLLISION DETECTION
        @enemies.each do |enemy|
            @bullets.each do |bullet|
                distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
                if distance < enemy.radius + bullet.radius
                    @enemies.delete enemy
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                end
            end
        end
        @enemies.each do |enemy|
            @booms.each do |boom|
                distance_1 = Gosu.distance(enemy.x, enemy.y, boom.x, boom.y)
                if distance_1 < enemy.radius + boom.radius
                    @enemies.delete enemy
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                end
            end
        end
        @enemies.each do |enemy|
            @back_ups.each do |back_up|
                distance_2 = Gosu.distance(enemy.x, enemy.y, back_up.x, back_up.y)
                if distance_2 < enemy.radius + back_up.radius
                    @enemies.delete enemy
                    @back_ups.delete back_up
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @explosions.push Explosion.new(self, back_up.x, back_up.y)
                end
            end
        end

        # CLEANING UP ARRAYS
        # The arrays should only have the objects that can be seen in the window
        # Delete explosions that stop drawing itself after its sixteen frames of images
        @explosions.each do |explosion|
            @explosions.delete explosion if explosion.finished
        end
        @bullets.each do |bullet|
            @bullets.delete bullet if not bullet.onscreen?
        end
        @enemies.each do |enemy|
            @enemies.delete enemy if enemy.y - enemy.radius > HEIGHT 
        end
        @booms.each do |boom|
            @booms.delete boom if boom.finished
        end
        @back_ups.each do |back_up|
            @back_ups.delete back_up if back_up.y + back_up.radius < 0
        end
        @stars.each do |star|
            @stars.delete star if star.finished
        end
    end

    def button_down(id)
        # Get one bullet per button press
        if id == Gosu::KbSpace
            @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
        end
        # Activate the bomb throwing status
        if id == Gosu::KbB
            @boom_it = true
        end
        # Deactivate the bomb throwing status
        if id == Gosu::KbS
            @boom_it = false
        end
        # Call for back up
        if id == Gosu::KbC
            @need_back_up = true
        end
    end 
end

window = SectorFive.new
window.show