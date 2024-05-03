# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class Enemy
    GROUND_LEVEL = 426
    VELOCITY = 6
    STUNNING_TIME = 200
    COOLDOWN_AFTER_HITTING = 100
    attr_reader :x, :y, :radius, :is_hurting, :hurt_until, :until_next_hit
    def initialize(window)
        @window = window
        @radius = 32
        @x = rand(@window.width - 2 * @radius) + @radius
        @y = GROUND_LEVEL
        @enemy_images = Gosu::Image.load_tiles("images/enemy.png", 64, 64)
        @current_enemy_image = @enemy_images[0]
        # To keep track of the enemy's direction and state,
        # so the appropriate images can be drawn
        @enemy_direction = rand(1) > 0.5 ? :left : :right
        @is_hurting = false
        # To keep track of the enemy's stunned time
        @hurt_until = 0
        @until_next_hit = 0
    end

    # TO DRAW THE ENEMY
    # To find the appropriate image based on enemy's state
    def current_enemy_image
        if not @is_hurting
            image_index = (Gosu::milliseconds / 90)  % 4
            @current_enemy_image = @enemy_images[image_index]
        else
            @current_enemy_image = @enemy_images[4]
        end
    end
    # To draw the appropriate image based on enemy's direction
    def draw
        @current_enemy_image.draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,-1,1) if @enemy_direction == :right
        @current_enemy_image.draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,1,1) if @enemy_direction == :left
    end

    # TO MOVE THE ENEMY
    def can_hit_other
        @until_next_hit = 0
    end
    def hit_other
        change_direction()
        @until_next_hit = COOLDOWN_AFTER_HITTING
    end
    def change_direction
        return @enemy_direction = :left if @enemy_direction == :right
        return @enemy_direction = :right if @enemy_direction == :left
    end
    def move
        # To change the enemy's direction
        @enemy_direction = :right if @x - @radius <= 0
        @enemy_direction = :left if @x + @radius >= @window.width
        # To move the enemy 
        @x += VELOCITY if @enemy_direction == :right
        @x -= VELOCITY if @enemy_direction == :left
    end
    def hurt
        @is_hurting = true
        # To stun the hero for STUNNING TIME/1000(s)
        @hurt_until = STUNNING_TIME
    end
    def stop_hurting
        @y += 5
    end
end