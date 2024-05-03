class Time
    TIME_FONT_SIZE = 46
    def initialize(window)
        @window = window
        @time_font = Gosu::Font.new(TIME_FONT_SIZE, :name => "fonts/pixel.ttf")
        @time, @time_m, @time_s = 0
    end

    def draw
        time = @time_m == 0 ? "#{@time_s}S" : "#{@time_m}M #{@time_s}S"
        x_time = @window.width / 2 - @time_font.text_width(time) / 2
        y_time = 12
        @time_font.draw(time,x_time,y_time,ZOrder::MIDDLE)
    end

    def timing
        @time = (Gosu::milliseconds / 1000)
        @time_m = @time / 60
        @time_s = @time % 60
        return @time_s if @time_m == 0
        return @time_s, @time_m
    end
end