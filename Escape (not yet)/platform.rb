class Platform
    FRICTION = 0.7
    ELASTICITY = 0.8
    attr_reader :body, :width, :height
    def initialize(window, x, y)
        space = window.space
        @width = 94
        @height = 20
        # TO CREATE THE PLATFORM
        @body = CP::Body.new_static
        # To set the position
        @body.p = CP::Vec2.new(x, y)
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
        # To add shape of the platform to the space
        space.add_shape(shape)
        @image = Gosu::Image.new("images/platform.png")
    end

    def draw
        @image.draw_rot(@body.p.x, @body.p.y, 1, 0)
    end
end