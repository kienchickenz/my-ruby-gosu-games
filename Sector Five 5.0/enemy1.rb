class Enemy1
    # How fast the enemy move
    SPEED = 3
    attr_reader :x, :y, :radius, :is_got_shot
    def initialize(window)
        @radius = 16
        @y = 0
        # The whole enemy should be fit in the window
        # ( Make a random number between two values by passing the difference between 
        # the minimum and maximum values to the rand method and then adding the minimum value )
        @x = rand(window.width - 2 * @radius) + @radius
        @image = Gosu::Image.new("images/enemy1.png")
        @is_got_shot = false
    end

    def move
        @y += SPEED
    end

    def draw
        # Draw_rot method centers the image on the x and y values as the first two parameters.
        # Rotate the enemy oppositely  
        @image.draw_rot(@x, @y, 1, 180)  
    end

    def got_shot
        @is_got_shot = true
    end
end   