class Player
    # How fast the ship turn
    ROTATION_SPEED = 5
    # How fast the ship move
    ACCELERATION = 1.5
    # How fast the ship stop when not pressing button
    FRICTION = 0.9
    # Get instance variables,
    # then return them appropriately
    attr_reader :x, :y, :angle, :radius
    def initialize(window)
        @x = 500
        @y = 350
        @angle = 0
        @image = Gosu::Image.new("images/player.png")
        # Move the ship
        @velocity_x = 0
        @velocity_y = 0

        @radius = 12
        @window = window
    end

    def draw
        # Draw_rot method centers the image on the x and y values as the first two parameters.
        @image.draw_rot(@x, @y, 1, @angle)
    end

    def turn_right
        @angle += ROTATION_SPEED
    end
    def turn_left
        @angle -= ROTATION_SPEED
    end

    def accelerate
        # Find the velocity based on angle by mathematical sin/cos functions
        @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
        @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
    end

    def move
        # Make the ship move
        @x += @velocity_x
        @y += @velocity_y
        # Slow down instead of stopping the ship when not pressing the button
        @velocity_x *= FRICTION 
        @velocity_y *= FRICTION 
        # Make the ship bounce off the edges
        if @x > @window.width - @radius
            @velocity_x *= -1
            @x = @window.width - @radius
        end
        if @x - @radius < 0
            @velocity_x *= -1
            @x = @radius
        end
        if @y > @window.height - @radius
            @velocity_y *= -1
            @y = @window.height - @radius
        end
    end
end