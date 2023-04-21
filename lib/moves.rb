# frozen_string_literal: true

# methods in this module all return boolean values - whether or not a given move is a valid one.
module Moves
  # Main methods for each piece type
  def pawn_moves(color, piece, destination)
    return false if piece == nil || destination == nil

    first = first_move?(color, piece)
    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if first && clear && one_or_two_ahead?(color, piece[0], destination[0])
    return true if !first && !capture && clear && one_ahead?(color, piece[0], destination[0])
    return true if capture && valid_diagonal?(color, piece, destination)

    puts 'Invalid move! Please enter a valid move for a pawn.'
    false
  end

  def rook_moves(color, piece, destination)
    return false if piece == nil || destination == nil

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_rook_moves(color, piece, destination)
    return true if capture && valid_rook_moves(color, piece, destination)

    puts 'Invalid move! Please enter a valid move for a rook.'
    false
  end

  # Helper methods for all moves
  def clear_path?(piece, destination)
    row_range = get_row_range(piece[0], destination[0])
    column_range = get_column_range(piece[1], destination[1])

    array_length_match(row_range, column_range)
    all_clear?(row_range, column_range, piece, destination)
  end

  def get_row_range(starting_row, ending_row)
    starting_row <= ending_row ? (starting_row..ending_row).to_a : (ending_row..starting_row).to_a
  end

  def get_column_range(starting_column, ending_column)
    starting_column <= ending_column ? (starting_column..ending_column).to_a : (ending_column..starting_column).to_a
  end

  def array_length_match(row_range, column_range)
    if column_range.length == 1 && row_range.length > 1
      row_range.each_index { |index| column_range[index] = column_range[0] }
    elsif row_range.length == 1 && column_range.length > 1
      column_range.each_index { |index| row_range[index] = row_range[0] }
    end
  end

  def all_clear?(row_range, column_range, piece, destination)
    array = []

    row_range.reverse! if piece[0] > destination[0]
    column_range.reverse! if piece[1] > destination[1]

    row_range.each_index do |index|
      array[index] = grid[row_range[index]][column_range[index]].match(empty_circle) ? true : false
    end

    array.shift

    return true if array.all?(true)

    false
  end

  def capturing?(color, piece, destination)
    row_range = get_row_range(piece[0], destination[0])
    column_range = get_column_range(piece[1], destination[1])

    array_length_match(row_range, column_range)
    opponent_at_end?(color, row_range, column_range, piece, destination)
  end

  def opponent_at_end?(color, row_range, column_range, piece, destination)
    array = []

    row_range.reverse! if piece[0] > destination[0]
    column_range.reverse! if piece[1] > destination[1]

    if color == white
      row_range.each_index do |index|
        p "black symbols? #{black_symbols_array.any? { |el| el == grid[row_range[index]][column_range[index]][1..-2] }}"
        array[index] = if !grid[row_range[index]][column_range[index]].match(empty_circle) &&
                          black_symbols_array.any? { |el| el == grid[row_range[index]][column_range[index]][1..-2] }
                         true
                       else
                         false
                       end
      end
    else
      row_range.each_index do |index|
        p "white symbols? #{white_symbols_array.any? { |el| el == grid[row_range[index]][column_range[index]][1..-2] }}"
        array[index] = if !grid[row_range[index]][column_range[index]].match(empty_circle) &&
                          white_symbols_array.any? { |el| el == grid[row_range[index]][column_range[index]][1..-2] }
                         true
                       else
                         false
                       end
      end
    end
    array.shift
    return true if array[-1] == true

    false
  end


  # Helper methods for pawn moves
  def first_move?(color, piece)
    return true if color == white && piece[0] == 6
    return true if color == black && piece[0] == 1

    false
  end

  def one_or_two_ahead?(color, starting_row, ending_row)
    return true if color == white && (starting_row - ending_row == 1 || starting_row - ending_row == 2)
    return true if color == black && (starting_row - ending_row == -1 || starting_row - ending_row == -2)

    false
  end

  def one_ahead?(color, starting_row, ending_row)
    return true if color == white && starting_row - ending_row == 1
    return true if color == black && starting_row - ending_row == -1

    false
  end

  def valid_diagonal?(color, piece, destination)
    if color == white &&
       piece[0] - destination[0] == 1 &&
       (piece[1] - destination[1] == 1 ||
        piece[1] - destination[1] == -1)
      true
    elsif color == black &&
          piece[0] - destination[0] == -1 &&
          (piece[1] - destination[1] == 1 ||
          piece[1] - destination[1] == -1)
      true
    else
      false
    end
  end

  # Helper methods for rook moves
  def valid_rook_moves(color, piece, destination)
    return true if valid_vertical(color, piece, destination) || valid_horizontal(color, piece, destination)

    false
  end

  def valid_vertical(color, piece, destination)
    return true if piece[0] == destination[0]

    false
  end

  def valid_horizontal(color, piece, destination)
    return true if piece[1] == destination[1]

    false
  end


  # def rook_moves(move_array, color, capturing = false)
  #   starting_row = move_array[0][0]
  #   ending_row = move_array[1][0]
  #   starting_column = move_array[0][1]
  #   ending_column = move_array[1][1]
    
  #   true_array = rook_moving_up(starting_row, ending_row, starting_column, ending_column) if starting_row > ending_row
  #   true_array = rook_moving_down(starting_row, ending_row, starting_column, ending_column) if starting_row < ending_row
  #   true_array = rook_moving_left(starting_row, ending_row, starting_column, ending_column) if starting_column > ending_column
  #   true_array = rook_moving_right(starting_row, ending_row, starting_column, ending_column) if starting_column < ending_column

  #   return true if true_array.all? == true || true_array.nil?

  #   puts 'Invalid move! Please enter a valid move for a rook.'
  #   false
  # end

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
    array_of_squares.each { |coord| true_array << grid[coord[0]][coord[1]].match(empty_circle) ? true : false }
    true_array
  end
end
