class BackUp
    # How fast the ship move
    SPEED = 4
    attr_reader :x, :y, :radius
     def initialize(window, x)
        @radius = 16
        @y = window.height
        @x = x
        @image = Gosu::Image.new("images/back_up.png")
    end

    def move
        @y -= SPEED
    end

    def draw
        # Make x and y represent the center of the ship
        @image.draw(@x - @radius, @y - @radius, 1)
    end
end