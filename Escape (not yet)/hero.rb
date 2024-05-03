class Hero
    # When hero is on the ground
    RUN_IMPULSE = 600
    FLY_IMPULSE = 60
    # When hero is off the ground
    JUMP_IMPULSE = 36000
    AIR_JUMP_IMPULSE = 1200
    SPEED_LIMIT = 400
    FRICTION = 0.7
    ELASTICITY = 0.2
    attr_reader :off_ground, :x, :y
    def initialize(window, x, y)
        @window = window
        space = window.space
        @images = Gosu::Image.load_tiles("images/hero.png", 44, 44)
        # TO CREATE THE HERO
        # To make sure the hero doesn’t rotate, we set his rotational inertia to 100.0/0.
        # It's a seemingly strange thing, but Chipmunk is ok with it. When Chipmunk sees a value like
        # this, it treats it like infinity. If hero’s rotational inertia is infinity, it means he won’t
        # rotate, no matter how much he is pushed.
        @body = CP::Body.new(50, 100.0/0)
        # To set the position
        @body.p = CP::Vec2.new(x, y)
        # To set the maximum speed
        @body.v_limit = SPEED_LIMIT
        # To create the shape
        bounds = [
                    CP::Vec2.new(-9, -15),
                    CP::Vec2.new(-9, 15),
                    CP::Vec2.new(9, 15),
                    CP::Vec2.new(9, -215)
        ]
        shape = CP::Shape::Poly.new(@body, bounds, CP::Vec2.new(0, 0))
        shape.u = FRICTION
        shape.e = ELASTICITY
        # To add both body and shape of the hero to the space
        space.add_body(@body)
        space.add_shape(shape)
        # To keep track of what the hero is doing,
        # so the appropriate images can be drawn
        @action = :stand
        @image_index = 0
        @off_ground = true
    end

    def end_game?
        return true if @body.p.x > 1620
    end

    def draw
        case @action
        when :run_right
            @images[@image_index].draw_rot(@body.p.x, @body.p.y, 2, 0)
            @image_index = ((@image_index + 0.2) % 6) + 3
        when :stand
            @images[0].draw_rot(@body.p.x, @body.p.y, 2, 0)
        when :jump_right
            @images[1].draw_rot(@body.p.x, @body.p.y, 2, 0)
        when :run_left
            # The draw_rot() method provides a way to flip those images HORIZONTALLY
            # when drawing them, by setting an optional parameter called scale_x to -1
            @images[@image_index].draw_rot(@body.p.x,@body.p.y,2,0,0.5,0.5,-1,1)
            @image_index = ((@image_index + 0.2) % 6) + 3
        when :jump_left
            @images[0].draw_rot(@body.p.x,@body.p.y,2,0,0.5,0.5,-1,1)
        end
    end

    # To check whether the rectangle of the footing object overlaps the hero’s foot box.
    def touching?(footing)
        x_diff = (@body.p.x - footing.body.p.x).abs
        # 30 is the distance between y-position of the hero, 
        # and y-position of the rectangle that represents his feet
        y_diff = (@body.p.y + 30 - footing.body.p.y).abs
        x_diff < footing.width and y_diff < footing.height
    end
    def check_footing(things)
        @off_ground = false
        things.each do |thing|
            off_ground = true if touching?(thing)
        end
    end
    
    # TO MOVE THE HERO
    def stand
        @action = :stand if not @off_ground
    end
    # To push hero in the appropriate direction
    def move_right
        if @off_ground
            @action = :jump_right
            @body.apply_impulse(CP::Vec2.new(FLY_IMPULSE,0), CP::Vec2.new(0,0))
        else
            @action = :run_right
            @body.apply_impulse(CP::Vec2.new(RUN_IMPULSE,0), CP::Vec2.new(0,0))
        end
    end
    def move_left
        if @off_ground
            @action = :jump_left
            @body.apply_impulse(CP::Vec2.new(FLY_IMPULSE,0), CP::Vec2.new(0,0))
        else
            @action = :run_left
            @body.apply_impulse(CP::Vec2.new(RUN_IMPULSE,0), CP::Vec2.new(0,0))
        end
    end
    # To get hero moving up to the next platform
    def jump
        if @off_ground
            @body.apply_impulse(CP::Vec2.new(0,-AIR_JUMP_IMPULSE), CP::Vec2.new(0,0))
        else
            @body.apply_impulse(CP::Vec2.new(0,-JUMP_IMPULSE), CP::Vec2.new(0,0))
            if @action == :left
                @action = :jump_left
            else
                @action = :jump_right
            end
        end
    end
end