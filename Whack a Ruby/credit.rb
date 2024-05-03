class Credit
    SPEED = 1
    attr_reader :y
    def initialize(window, text, x, y)
        @x = x
        @y = @initial_y = y
        @text = text
        @font = Gosu::Font.new(24, :name => "fonts/501.ttf")
    end

    def move
        @y -= SPEED
    end

    def draw
        @font.draw(@text, @x, @y, 1)
    end

    def reset
        @y = @initial_y
    end
end