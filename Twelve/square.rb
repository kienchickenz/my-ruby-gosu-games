require 'gosu'
# The game is made from a six-by-six grid of squares. 
# Each square is 100 pixels on a side,
# include a 2 pixel black border around the edge of each square,
# and a 20-pixel border around the whole board, and 50-pixel border-top
# so the whole window will be 690 by 640 pixels.
class Square
    TOP_BORDER = 50
    attr_reader :row, :column, :number, :color
    def initialize(window,column,row,color)
        @@colors ||= {  red: Gosu::Color.argb(0xaaff0000),
                        green: Gosu::Color.argb(0xaa00ff00),
                        blue: Gosu::Color.argb(0xaa0000ff)  }
        @@font ||= Gosu::Font.new(72)
        @@window ||= window
        @row = row
        @column = column
        @color = color
        @number = 1
    end

    def draw
        if @number != 0
            # Use the draw_quad method to make the colored square
            x1 = 22 + 100 * @column
            y1 = 22 + 100 * @row + TOP_BORDER
            x2 = x1 + 96
            y2 = y1
            x3 = x2
            y3 = y2 + 96
            x4 = x1
            y4 = y3
            c = @@colors[@color]
            @@window.draw_quad(x1,y1,c,x2,y2,c,x3,y3,c,x4,y4,c,2)
            # Draw number exactly at the center of the square
            x_center = x1 + 48
            x_text = x_center - @@font.text_width("#{number}") / 2
            y_text = y1 + 12
            @@font.draw("#{number}", x_text, y_text, 1)
        end
    end

    # Clear a square
    def clear
        @number = 0
    end

    # Update a square
    def set(color, number)
        @color = color
        @number = number
    end

    # ADD HIGHLIGHTS
    # Each of the highlights is made from 4 rectangles(4x96) 
    def highlight(state)
        case state
        when :start
            c = Gosu::Color::WHITE
        when :illegal
            c = Gosu::Color::RED
        when :legal
            c = Gosu::Color::GREEN
        end
        x1 = 22 + @column * 100 
        y1 = 22 + @row * 100 + TOP_BORDER
        draw_horizontal_highlight(x1,y1,c)
        draw_horizontal_highlight(x1,y1 + 92,c)
        draw_vertical_highlight(x1,y1,c)
        draw_vertical_highlight(x1 + 92,y1,c)
    end

    # Create horizontal rectangles for the highlights
    def draw_horizontal_highlight(x1,y1,c)
        x2 = x1 + 96
        y2 = y1
        x3 = x2
        y3 = y2 + 4
        x4 = x1
        y4 = y3
        @@window.draw_quad(x1,y1,c,x2,y2,c,x3,y3,c,x4,y4,c,3)
    end

    # Create vertical rectangles for the highlights
    def draw_vertical_highlight(x1,y1,c)
        x2 = x1 + 4
        y2 = y1
        x3 = x2
        y3 = y2 + 96
        x4 = x1
        y4 = y3
        @@window.draw_quad(x1,y1,c,x2,y2,c,x3,y3,c,x4,y4,c,3)
    end
end