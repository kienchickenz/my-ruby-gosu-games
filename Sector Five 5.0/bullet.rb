class Bullet
    # How fast the bullet move
    SPEED = 10
    attr_reader :x, :y, :radius
    def initialize(window, x, y, angle)
        @x = x
        @y = y
        @direction = angle
        @image = Gosu::Image.new("images/bullet.png")
        @radius = 5
        @window = window
    end

    def move
        @x += Gosu.offset_x(@direction, SPEED)
        @y += Gosu.offset_y(@direction, SPEED)
    end

    def draw
        # Make x and y represent the center of the bullet
        # so it appears in the middle of the ship when shooting
        @image.draw(@x - @radius, @y - @radius, 1)
    end

    def onscreen?
        right = @window.width + @radius
        left = -@radius
        top = -@radius
        bottom = @window.height + @radius
        @x > left and @x < right and @y > top and @y < bottom
    end
end