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
    starting_row = move_array[0][0]
    ending_row = move_array[1][0]
    starting_column = move_array[0][1]
    ending_column = move_array[1][1]
    
    true_array = rook_moving_up(starting_row, ending_row, starting_column, ending_column) if starting_row > ending_row
    true_array = rook_moving_down(starting_row, ending_row, starting_column, ending_column) if starting_row < ending_row
    true_array = rook_moving_left(starting_row, ending_row, starting_column, ending_column) if starting_column > ending_column
    true_array = rook_moving_right(starting_row, ending_row, starting_column, ending_column) if starting_column < ending_column

    return true if true_array.all? == true || true_array.nil?

    puts 'Invalid move! Please enter a valid move for a rook.'
    false
  end

  def rook_moving_up(starting_row, ending_row, starting_column, ending_column)
    array_of_squares = []
    if starting_column == ending_column && starting_row > ending_row
      range = (ending_row + 1...starting_row).to_a
      range.each { |row| array_of_squares << [row, starting_column] }

      true_array = all_empty_cirles(array_of_squares)
      true_array
    end
  end

  def rook_moving_down(starting_row, ending_row, starting_column, ending_column)
    array_of_squares = []
    if starting_column == ending_column && starting_row < ending_row
      range = (starting_row + 1...ending_row).to_a
      range.each { |row| array_of_squares << [row, starting_column] }

      true_array = all_empty_cirles(array_of_squares)
      true_array
    end
  end

  def rook_moving_left(starting_row, ending_row, starting_column, ending_column)
    array_of_squares = []
    if starting_row == ending_row && starting_column > ending_column
      range = (ending_column + 1...starting_column).to_a
      range.each { |column| array_of_squares << [starting_row, column] }

      true_array = all_empty_cirles(array_of_squares)
      true_array
    end
  end

  def rook_moving_right(starting_row, ending_row, starting_column, ending_column)
    array_of_squares = []
    if starting_row == ending_row && starting_column < ending_column
      range = (starting_column + 1...ending_column).to_a
      range.each { |column| array_of_squares << [starting_row, column] }

      true_array = all_empty_cirles(array_of_squares)
      true_array
    end
  end

  def knight_moves(move_array, color, capturing = false)

  end

  def bishop_moves(move_array, color, capturing = false)

  end

  def queen_moves(move_array, color, capturing = false)

  end

  def king_moves(move_array, color, capturing = false)
    starting_row = move_array[0][0]
    ending_row = move_array[1][0]
    starting_column = move_array[0][1]
    ending_column = move_array[1][1]

    return true if (starting_row - ending_row == 1 || starting_row - ending_row == -1) && grid[ending_row][ending_column].match(empty_circle)
    return true if (starting_column - ending_column == 1 || starting_column - ending_column == -1) && grid[ending_row][ending_column].match(empty_circle)
    
    false
  end

  def all_empty_cirles(array_of_squares)
    true_array = []
    array_of_squares.each { |coord| grid[coord[0]][coord[1]].match(empty_circle) ? true_array << true : true_array << false }
    true_array
  end
end
