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
end
