# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class Hero
    GROUND_LEVEL = 426
    VELOCITY = 4
    STUNNING_TIME = 300
    # To handle physics rules
    VERTICAL_VELOCITY = 38
    VERTICAL_VELOCITY_FROM_ENEMY = 25
    GRAVITY = 1.5
    attr_reader :x, :y, :radius, :is_jumping, :is_hurting, :hurt_until
    def initialize(window)
        @x = 100
        @y = GROUND_LEVEL
        @hero_images = Gosu::Image.load_tiles("images/hero.png", 64, 64)
        @current_hero_image = @hero_images[0]
        @radius = 32
        # To keep track of the hero's direction and actions,
        # so the appropriate images can be drawn
        @hero_direction = :right
        @is_running = false
        @is_jumping = false
        @is_hurting = false
        # To keep track of the hero's stunned time
        @hurt_until = 0
    end

    # TO DRAW THE HERO
    # To find the appropriate image based on hero's action
    def current_hero_image
        if @is_hurting
            @current_hero_image = @hero_images[6]
        elsif @is_jumping
            @current_hero_image = @vertical_velocity > 0 ? @hero_images[4] : @hero_images[5]
        elsif @is_running
            # To change image every 0.1s
            image_index = (Gosu::milliseconds / 100 % 3) + 1
            @current_hero_image = @hero_images[image_index]
        else
            @current_hero_image = @hero_images[0]
        end
    end
    # To draw the appropriate image based on hero's direction
    def draw
        @current_hero_image.draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,1,1) if @hero_direction == :right
        @current_hero_image.draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,-1,1) if @hero_direction == :left
    end

    # TO MOVE THE HERO
    def stand
        @is_running = false
    end
    def run(way)
        @x += way == :right ? VELOCITY : -VELOCITY
        @hero_direction = way == :right ? :right : :left
        @is_running = true
    end
    def jump
        # The hero can't not jump if he is not on the ground
        return if @is_jumping
        @is_jumping = true
        # To reset the @vertical_velocity before every jump
        @vertical_velocity = VERTICAL_VELOCITY
    end
    def jump_from_enemy
        @is_jumping = true
        @vertical_velocity = VERTICAL_VELOCITY_FROM_ENEMY
    end
    def handle_jump
        @y -= @vertical_velocity
        # When the hero is at the highest point and begins to fall
        if @vertical_velocity.floor(2) == 0 
            @vertical_velocity = -1
        # When the hero is falling
        elsif @vertical_velocity < 0
            @vertical_velocity = @vertical_velocity * GRAVITY
        # When the hero is going up
        else
            @vertical_velocity = @vertical_velocity / GRAVITY
        end
        # To check whether he has finished his jump
        if @y.ceil >= GROUND_LEVEL
            @y = GROUND_LEVEL
            return @is_jumping = false
        end
    end
    def hurt
        @is_hurting = true
        # To stun the hero for STUNNING TIME/1000(s)
        @hurt_until = Gosu::milliseconds + STUNNING_TIME
    end
    def stop_hurting
        @is_hurting = false
        @hurt_until = 0
    end
end