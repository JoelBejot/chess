# frozen_string_literal: true

# module for storing all the valid moves
module Moves
  # If a pawn is in its starting position, it can advance one of two squares
  # Otherwise, it can only advance one square
  # If a pawn is capturing another piece, it can only capture to a forward diagonal
  def pawn_moves(move_array, color, capturing = false)
    starting_row = move_array[0][0]
    ending_row = move_array[1][0]
    starting_column = move_array[0][1]
    ending_column = move_array[1][1]

    if color == white && starting_row == 6
      return true if (starting_row - ending_row) == 1 || (starting_row - ending_row) == 2
    elsif color == black && starting_row == 1
      return true if (starting_row - ending_row) == -1 || (starting_row - ending_row) == -2
    elsif color == white && starting_row != 6
      return true if (starting_row - ending_row) == 1
    elsif color == black && starting_row != 1
      return true if (starting_row - ending_row) == -1
    end

    if color == white && capturing
      return true if ((starting_row - ending_row) == -1 && (starting_column - ending_column) == -1) ||
                     ((starting_row - ending_row) == -1 && (starting_column - ending_column) == 1)
    elsif color == black && capturing
      return true if ((starting_row - ending_row) == 1 && (starting_column - ending_column) == -1) ||
                     ((starting_row - ending_row) == 1 && (starting_column - ending_column) == 1)
    end
    puts 'Invalid move! Please enter a valid move for a pawn.'
    false
  end

  def rook_moves(move_array, color, capturing = false)
    p starting_row = move_array[0][0]
    p ending_row = move_array[1][0]
    p starting_column = move_array[0][1]
    p ending_column = move_array[1][1]

    # starting row and ending row can be anything between 0 and 7, but column must be the same, OR
    # starting column and ending column can be anthing between 0 and 7, but row must be the same
    # AND there can't be anything except empty_circles between the beginning and ending, except if capturing is true
    # if capturing is true, there can be a piece of opposite color at the ending square

    array_of_squares = []
    if starting_column == ending_column && starting_row > ending_row
      # [starting_row - 1..ending_row].each_with_index { |row, index| array_of_squares[index] << [row, starting_column] }
      range = (ending_row..starting_row).to_a
      p range
      i = starting_row
      while i != ending_row
        i -= 1
        # shovel indexes into array of squares
      end
    end
    p array_of_squares

    # if starting_row.between?(0, 7) && ending_row.between?(0, 7) && starting_column == ending_column

    puts 'Invalid move! Please enter a valid move for a rook.'
    false
  end
end
