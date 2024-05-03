class Wall
    FRICTION = 0.7
    ELASTICITY = 0.2
    def initialize(window, x, y, width, height)
        space = window.space
        # To represent the CENTER of the wall
        @x = x
        @y = y
        @width = width
        @height = height
        # TO CREATE THE BOULDER
        @body = CP::Body.new_static
        # To set the position
        @body.p = CP::Vec2.new(x, y)
        # To create the shape
        bounds =[
                    CP::Vec2.new(- width / 2, - height / 2),
                    CP::Vec2.new(- width / 2, height / 2),
                    CP::Vec2.new(width / 2, height / 2),
                    CP::Vec2.new(width / 2, - height / 2)
                ]
        shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
        shape.u = FRICTION
        shape.e = ELASTICITY
        # To add shape of the platform to the space
        space.add_shape(shape)
    end
end