class Enemy
    # How fast the enemy move
    SPEED = 2
    attr_reader :x, :y, :radius
    def initialize(window)
        @radius = 16
        @y = 0
        # The whole enemy should be fit in the window
        # ( Make a random number between two values by passing the difference between 
        # the minimum and maximum values to the rand method and then adding the minimum value )
        @x = rand(window.width - 2 * @radius) + @radius
        @image = Gosu::Image.new("images/enemy.png")
    end

    def move
        @y += SPEED
    end

    def draw
        # Draw_rot method centers the image on the x and y values as the first two parameters.
        # Rotate the enemy oppositely
        @image.draw_rot(@x, @y, 1, 180)
    end
end