# To setup for layering images on top of each other
module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

class Hero
    # How fast the hero move
    VELOCITY = 3
    FRAMES_PER_IMAGE = 3
    attr_reader :x, :y
    attr_accessor :standing_side
    def initialize(window)
        @x = 100
        @y = 426
        @hero_images = Gosu::Image.load_tiles("images/hero.png", 64, 64)
        @radius = 32
        @image_index = 0
        @frames = 0
        # To keep track of what the hero is doing,
        # so the appropriate images can be drawn
        @action = :stand
        @standing_side = :right
    end

    def draw
        case @action
        when :stand
            if @standing_side == :right
            @hero_images[0].draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,1,1)
            elsif @standing_side == :left
            # The draw_rot() method provides a way to flip those images HORIZONTALLY
            # when drawing them, by setting an optional parameter called scale_x to -1
            @hero_images[0].draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,-1,1)
            end
        when :run_right
            @hero_images[@image_index].draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,1,1)
            if @frames < FRAMES_PER_IMAGE
                @frames += 1
            else
                @image_index = (@image_index % 3) + 1
                @frames = 0
            end
        when :run_left
            # The draw_rot() method provides a way to flip those images HORIZONTALLY
            # when drawing them, by setting an optional parameter called scale_x to -1
            @hero_images[@image_index].draw_rot(@x,@y,ZOrder::MIDDLE,0,0.5,0.5,-1,1)
            if @frames < FRAMES_PER_IMAGE
                @frames += 1
            else
                @image_index = (@image_index % 3) + 1
                @frames = 0
            end
        end
    end

    # TO MOVE AND KEEP TRACK OF HERO'S ACTIONS
    def run_right
        @action = :run_right
        @x += VELOCITY
    end
    def run_left
        @action = :run_left
        @x -= VELOCITY
    end
    def stand
        @action = :stand
    end
end