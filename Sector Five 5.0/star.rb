class Star
    FRAMES_PER_IMAGE = 2
    attr_reader :finished
    def initialize(window)
        @radius = 8
        @x = rand(window.width - @radius) + 2 * @radius
        @y = rand(window.height - @radius) + 2 * @radius
        @image = Gosu::Image.load_tiles("images/star.png", 16, 16)
        @finished = false
        @image_index = 7
        @frame_count = FRAMES_PER_IMAGE
    end

    def draw
        # Draw 1 image per 2 frames until finishing the animation
        if @image_index > -1
            @image[@image_index].draw(@x - @radius, @y - @radius)
            if @frame_count == 0
                @image_index -= 1
                @frame_count = FRAMES_PER_IMAGE
            else
                @frame_count -= 1
            end
        else
            @finished = true
        end
    end
end