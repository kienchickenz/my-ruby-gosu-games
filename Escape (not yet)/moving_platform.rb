# The platform will be pushed all the way back through the center position until it
# reaches a distance from the center equal to the range on the other side. And
# then repeat. So the platform moves back and forth, turning around at the declared range.
class MovingPlatform
    FRICTION = 0.7
    ELASTICITY = 0.8
    SPEED_LIMIT = 40
    attr_reader :body, :width, :height
    def initialize(window, x, y, range, direction)
        space = window.space
        @window = window
        @x_center = x
        @y_center = y
        @direction = direction
        @range = range
        @body = CP::Body.new(50000, 100.0/0)
        @width = 94
        @height = 20
        @body.v_limit = SPEED_LIMIT
        # To initialize the platform's position
        if @direction == :horizontal
            @body.p = CP::Vec2.new(x + range + 100, y)
            @move = :right
        else
            @body.p = CP::Vec2.new(x, y + range + 100)
            @move = :down
        end
        # To create the shape
        bounds =[
                    CP::Vec2.new(-37, -10),
                    CP::Vec2.new(-37, 10),
                    CP::Vec2.new(37, 10),
                    CP::Vec2.new(37, -10)
                ]
        shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
        shape.u = FRICTION
        shape.e = ELASTICITY
        # To add both body and shape of the platform to the space
        space.add_body(@body)
        space.add_shape(shape)
        @image = Gosu::Image.new("images/platform.png")
        # To apply an upward force to keep our moving platforms from falling to the ground
        @body.apply_force(CP::Vec2.new(0,-20000000), CP::Vec2.new(0,0))
    end

    def move 
        case @direction
        when :horizontal
            if body.p.x > @x_center + @range and @move == :right
                @body.reset_forces
                @body.apply_force(CP::Vec2.new(0,-20000000), CP::Vec2.new(0,0))
                @body.apply_force(CP::Vec2.new(-20000000,0), CP::Vec2.new(0,0))
                @move = :left
            elsif @body.p.x < @x_center - @range and @move == :left
                @body.reset_forces
                @body.apply_force(CP::Vec2.new(0, -20000000), CP::Vec2.new(0,0))
                @body.apply_force(CP::Vec2.new(20000000, 0), CP::Vec2.new(0,0))
                @move = :right
            end
            # To ensure that when a boulder pushes the platform down a tiny bit, it's then moved back up
            @body.p.y = @y_center
        when :vertical
            if @body.p.y > @y_center + @range and @move == :down
                @body.reset_forces
                @body.apply_force(CP::Vec2.new(0,-25000000), CP::Vec2.new(0,0))
                @move = :up
            elsif @body.p.y < @y_center - @range and @move == :up
                @body.reset_forces
                @body.apply_force(CP::Vec2.new(0,-15000000), CP::Vec2.new(0,0))
                @move = :down
            end
        end
    end

    def draw
        @image.draw_rot(@body.p.x, @body.p.y, 0, 1)
    end
end