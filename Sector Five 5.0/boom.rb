class Boom
    FRAMES_PER_IMAGE = 2
    attr_reader :x, :y, :finished, :radius
    def initialize(window)
        @radius = 32
        @x = rand(window.width - 2 * @radius) + @radius
        @y = rand(window.height - 2 * @radius) + @radius
        @images = Gosu::Image.load_tiles("images/boom.png", 64, 64)
        @image_index = 0
        @finished = false
        @frame_count = FRAMES_PER_IMAGE
    end

    def draw
        # Draw 1 image per 2 frames until finishing the animation
        if @image_index < 12
            @images[@image_index].draw(@x - @radius, @y - @radius)
            if @frame_count == FRAMES_PER_IMAGE
                @image_index += 1
                @frame_count = 0
            else
                @frame_count += 1
            end
        else
            @finished = true
        end
    end
end