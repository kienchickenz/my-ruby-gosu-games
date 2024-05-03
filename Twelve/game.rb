require_relative 'square'

class Game
    TOP_BORDER = 50
    attr_reader :winning, :losing, :move_is_legal
    def initialize(window)
        @window = window
        @squares = []
        # Push exactly twelve of each color to the list
        color_list = []
        [:red, :green, :blue].each do |color|
            12.times do
                color_list.push color
            end
        end
        # Randomize the array
        color_list.shuffle!
        # Assign the color to each square
        (0..5).each do |row|
            (0..5).each do |column|
                index = row * 6 + column
                @squares.push Square.new(@window,column,row,color_list[index])
            end
        end
        @font = Gosu::Font.new(36)
        # To determine whether the player won or not
        @winning = false
        @losing = false
        @remaining_square = 0
        # To set the appropriate sound effect
        @move_is_legal = false
    end

    def draw
        # Draw the board
        @squares.each do |square|
            square.draw
        end
        # DRAW THE HIGHLIGHTS
        # No highlighting between moves
        if @start_square == nil
            return
        end
        # Highlight the @start_square
        @start_square.highlight(:start)
        return if @current_square == nil or @current_square == @start_square
        # Highlight the @end_square
        if move_is_legal?(@start_square, @current_square)
            @current_square.highlight(:legal)
        else
            @current_square.highlight(:illegal)
        end
    end

    # HANDLE USER'S INTERFACE
    # Check whether @start_square and @end_square refer to squares
    def get_square(column,row)
        if column < 0 or column > 5 or row < 0 or row > 5
            return nil
        else
            return @squares[row * 6 + column]
        end
    end
    # Figure out which square is clicked on
    def handle_mouse_down(x,y)
        row = (y.to_i - 20 - TOP_BORDER) / 100
        column = (x.to_i - 20) / 100
        @start_square = get_square(column,row)
    end
    # Figure out which square the mouse is released
    def handle_mouse_up(x,y)
        row = (y.to_i - 20 - TOP_BORDER) / 100
        column = (x.to_i - 20) / 100
        @end_square = get_square(column,row)
        # Move the square if @start_square and @end_square refer to squares
        move(@start_square, @end_square) if @start_square and @end_square and @start_square != @end_square
        # Reset the square if @start_square or @end_square doesn't refer to squares
        @start_square = nil
    end
    # To figure out which square the mouse is on for highlighting
    def handle_mouse_move(x, y)
        row = (y.to_i - 20 - TOP_BORDER) / 100
        column = (x.to_i - 20) / 100
        @current_square = get_square(column, row)
    end

    # EXECUTE THE MOVE
    # Determine whether the move is valid
    def squares_between_in_row(square_1, square_2)
        the_squares = []
        if square_1.column < square_2.column
            column_start, column_end = square_1.column, square_2.column
        end
        if square_1.column > square_2.column
            column_start, column_end = square_2.column, square_1.column
        end
        (column_start .. column_end).each do |column|
            the_squares.push get_square(column, square_1.row)
        end
        return the_squares
    end
    def squares_between_in_column(square_1, square_2)
        the_squares = []
        if square_1.row < square_2.row
            row_start, row_end = square_1.row, square_2.row
        end
        if square_1.row > square_2.row
            row_start, row_end = square_2.row, square_1.row
        end
        (row_start .. row_end).each do |row|
            the_squares.push get_square(square_1.column, row)
        end
        return the_squares
    end
    # Go through all the things that would make a move invalid and test for those, one at a time. 
    # Any move that isn’t invalid for any of the conditions (4 conditions)
    # must be valid.
    def move_is_legal?(square_1, square_2)
        @move_is_legal = false
        # Check whether the @start_square is empty
        return false if square_1.number == 0
        # Create an array from @start_square to @end_square 
        if square_1.row == square_2.row
            @the_squares = squares_between_in_row(square_1, square_2)
        elsif square_1.column == square_2.column
            @the_squares = squares_between_in_column(square_1, square_2)
        # Check whether @start_square and @end_square is in same row or column
        else
            return false
        end
        # Remove any empty squares between @start_square and @end_square
        @the_squares.reject!{|square| square.number == 0}     
        # Check whether there is only @start_square and @end_square left
        return false if @the_squares.count != 2
        # Check whether @start_square and @end_square has the same color
        return false if @the_squares[0].color != @the_squares[1].color
        # VALID MOVE
        @move_is_legal = true
        return true
    end
    # Execute the move
    def move(square_1, square_2)
        if move_is_legal?(square_1, square_2)
            # VALID MOVE
            # Set the color, number of @end_square
            color = @the_squares[0].color
            number = @the_squares[0].number + @the_squares[1].number
            # Clear the two squares left in the squares array 
            @the_squares[0].clear
            @the_squares[1].clear       
            square_2.set(color, number)
        else
            return
        end
    end
    
    # DETERMINE WHETHER THE GAME IS END
    # Check every possible move until finding a legal one,
    # If don’t, the game is over
    def legal_move_for?(start_square)
        # Check whether start_square is empty 
        return false if start_square.number == 0
        # Check the moves from start_square to every square on the board
        @squares.each do |end_square|
            if start_square != end_square
                return true if move_is_legal?(start_square, end_square)
            end
        end
        return false
    end
    def end_game
        # Check legal moves for every square on the board
        @squares.each do |square|
            return if legal_move_for?(square)
        end
        # Check whether player win or lose
        # by counting the remaining squares
        @squares.each do |square|
            @remaining_square += 1 if square.number != 0
        end
        if @remaining_square == 3
            @winning = true
        else
            @losing = true
        end
    end
end