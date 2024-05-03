class Explosion
    FRAMES_PER_IMAGE = 2
    attr_reader :finished
    def initialize(window, x, y)
        @x = x
        @y = y
        @radius = 16
        # This method chops up the sprite sheet into rectangles and returns an array of images
        @images = Gosu::Image.load_tiles("images/explosions.png", 32, 32)
        @image_index = 0
        @finished = false

        @frame_count = FRAMES_PER_IMAGE
    end

    def draw
        # Draw 1 image per 2 frames until finishing the animation
        if @image_index < @images.count
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