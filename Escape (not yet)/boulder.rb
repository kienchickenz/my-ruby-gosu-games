class Boulder
    FRICTION = 0.7
    ELASTICITY = 0.95
    SPEED_LIMIT = 600
    attr_reader :body, :width, :height
    def initialize(window, x, y)
        # TO CREATE THE BOULDER
        # Body is initialized with two arguments, mass = 400, and rotational inertia = 4000.
        # Mass is a measure of resistance to changes in the velocity of the body,
        # and rotational inertia is a measure of resistance to changes in rotation.
        @body = CP::Body.new(400, 4000)
        # To set the position
        @body.p = CP::Vec2.new(x, y)
        # To set the maximum speed
        @body.v_limit = SPEED_LIMIT
        # To put vertices of the polygon, each a CP::Vec2 object, in an array called 
        # bounds. The vertices must be specified in a counter clockwise direction around
        # the polygon and the polygon MUST BE CONVEX, meaning that it doesn’t have
        # any indentations.
        bounds =[
                    CP::Vec2.new(-8, -8),
                    CP::Vec2.new(-15, 0),
                    CP::Vec2.new(-8, 8),
                    CP::Vec2.new(0, 15),
                    CP::Vec2.new(8, 8),
                    CP::Vec2.new(15, 0),
                    CP::Vec2.new(8, -8),
                    CP::Vec2.new(0, -15)
                ]
        # To create the shape
        shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
        shape.u = FRICTION
        shape.e = ELASTICITY
        # To test whether the hero is standing on a boulder
        @width = 32
        @height = 32
        # To add both body and shape of the boulder to the space
        window.space.add_body(@body)
        window.space.add_shape(shape)
        @image = Gosu::Image.new("images/boulder.png")

        # TO GET THE BOULDER MOVE
        # The method apply_impulse() in the Cp::Body class apply an instantaneous force to an object.
        # This force will get the object moving, but then lets it move on its own as gravity takes over.
        # The apply_impulse() method takes two arguments, both of type CP::Vec2,
        # >> The first argument is how much force to apply. 
        # >> The second is where to apply the force - relative to the center of the object
        # (Applying the force away from the center makes the boulder spin)
        @body.apply_impulse(CP::Vec2.new(rand(100000) - 50000, 100000),
                            CP::Vec2.new(rand * 0.8 - 0.4, 0))
        # The force of gravity, 400, multiplied by the mass of the boulder, which is also 400. 
        # This force of 160,000 is divided by the mass of the boulder to find its acceleration, 
        # which is 400. 
        # >> Each second the boulder will change its velocity by 400 in the downward direction.
    end

    def draw
        # To convert the angle before using it as
        # Chipmunk measures angles in radians, and 
        # Gosu measures angles in degrees.
        @image.draw_rot(@body.p.x, @body.p.y, @body.angle * (180 / Math::PI))    
    end
end
