class Camera
    attr_reader :x_offset, :y_offset
    def initialize(window, space_height, space_width)
        @window = window
        @window_width = window.width
        @space_width = space_width
        @x_offset_max = @space_width - @window_width
        @window_height = window.height
        @space_height = space_height
        @y_offset_max = @space_height - @window_height
    end
    # To calculate the offsets based on the location of a sprite
    def center_on(sprite, right_margin, bottom_margin)
        @x_offset = sprite.x - @window_width + right_margin
        @y_offset = sprite.y - @window_height + bottom_margin
        @x_offset = @x_offset_max if @x_offset > @x_offset_max
        @x_offset = 0 if @x_offset < 0
        @y_offset = @y_offset_max if @y_offset > @y_offset_max
        @y_offsey = 0 if @y_offset < 0
    end
    def view
        # The translate() method adds rather than subtracts the offsets to the position of any
        # object drawn in its block, so we send it -@x_offset and -@y_offset as parameters.
        @window.translate(-@x_offset, -@y_offset) do
            yeild
        end
    end
end