# frozen_string_literal: true

# methods in this module all return boolean values - whether or not a given move is a valid one.
module Moves
  KNIGHT_MOVES = [
    [1, 2], [-1, -2], [-1, 2], [1, -2],
    [2, 1], [-2, -1], [-2, 1], [2, -1]
  ].freeze

  KING_MOVES = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ].freeze

  # Have to see if any enemy can reach the king at the beginning of each move.
  # If so, then return false

  # Main methods for each piece type
  def pawn_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    first = first_move?(color, piece)
    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if first && clear && one_or_two_ahead?(color, piece, destination)
    return true if !first && !capture && clear && one_ahead?(color, piece, destination)
    return true if capture && valid_diagonal?(color, piece, destination)

    puts 'Invalid move! Please enter a valid move for a pawn.'
    false
  end

  def rook_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_rook_moves(piece, destination)
    return true if capture && valid_rook_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a rook.'
    false
  end

  def knight_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = true if grid[destination[0]][destination[1]].match(empty_circle)
    capture = opponent_at_end?(color, destination)

    return true if clear && valid_knight_moves(piece, destination)
    return true if capture && valid_knight_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a knight.'

    false
  end

  def bishop_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_bishop_moves(piece, destination)
    return true if capture && valid_bishop_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a bishop.'

    false
  end

  def queen_moves(color, piece, destination)
    return false if piece == nil || destination == nil

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    # p "clear = #{clear}"
    # p "capture = #{capture}"

    return true if clear && valid_queen_moves(piece, destination)
    return true if capture && valid_queen_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a queen.'

    false
  end

  def king_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    # check/checkmate methods - cannot move into a check or checkmate
    # return false if check or checkmate

    return true if clear && valid_king_moves(piece, destination)
    return true if capture && valid_king_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a king.'

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
    return false if row_range.nil? || column_range.nil? || row_range.length != column_range.length
    array = []

    row_range.reverse! if piece[0] > destination[0]
    column_range.reverse! if piece[1] > destination[1]

    row_range.each_index do |index|
      array[index] = grid[row_range[index]][column_range[index]].match(empty_circle) ? true : false
    end

    array.shift

    return true if array.all?(true) || array.nil?

    false
  end

  def capturing?(color, piece, destination)
    row_range = get_row_range(piece[0], destination[0])
    column_range = get_column_range(piece[1], destination[1])


    array_length_match(row_range, column_range)
    if piece[0] > destination[0]
      clear = all_clear?(row_range[1..-1], column_range[1..-1], piece, destination)
    else
      clear = all_clear?(row_range[0..-2], column_range[0..-2], piece, destination)
    end
    return true if clear && opponent_at_end?(color, destination)
  
  end

  def opponent_at_end?(color, destination)
    array = []

    if color == white
      array[0] = if black_symbols_array.any? { |el| el == grid[destination[0]][destination[1]][1..-2] }
                   true
                 else
                   false
                 end
    else
      array[0] = if white_symbols_array.any? { |el| el == grid[destination[0]][destination[1]][1..-2] }
                   true
                 else
                   false
                 end
    end

    return true if array[0] == true

    false
  end

  def all_empty_cirles(array_of_squares)
    true_array = []
    array_of_squares.each { |coord| true_array << grid[coord[0]][coord[1]].match(empty_circle) ? true : false }
    true_array
  end

  # Helper methods for pawn moves
  def first_move?(color, piece)
    return true if color == white && piece[0] == 6
    return true if color == black && piece[0] == 1

    false
  end

  def one_or_two_ahead?(color, piece, destination)
    if color == white &&
       (piece[0] - destination[0] == 1 || piece[0] - destination[0] == 2) &&
       piece[1] == destination[1]
      return true
    end

    if color == black &&
      (piece[0] - destination[0] == -1 || piece[0] - destination[0] == -2) &&
      piece[1] == destination[1]
     return true
    end

    false
  end

  def one_ahead?(color, piece, destination)
    if color == white &&
       piece[0] - destination[0] == 1 &&
       piece[1] == destination[1]
      return true
    end

    if color == black &&
       piece[0] - destination[0] == -1 &&
       piece[1] == destination[1]
      return true
    end

    false
  end

  def valid_diagonal?(color, piece, destination)
    if color == white &&
       piece[0] - destination[0] == 1 &&
       (piece[1] - destination[1]).abs == 1
      true
    elsif color == black &&
          piece[0] - destination[0] == -1 &&
          (piece[1] - destination[1]).abs == 1 
      true
    else
      false
    end
  end

  # Helper methods for rook moves
  def valid_rook_moves(piece, destination)
    return true if valid_vertical(piece, destination) || valid_horizontal(piece, destination)

    false
  end

  def valid_vertical(piece, destination)
    return true if piece[0] == destination[0]

    false
  end

  def valid_horizontal(piece, destination)
    return true if piece[1] == destination[1]

    false
  end

  # Helper method for knight moves
  def valid_knight_moves(piece, destination)
    array = []
    array[0] = piece[0] - destination[0]
    array[1] = piece[1] - destination[1]
    return true if KNIGHT_MOVES.any?(array)

    false
  end

  # Helper method for bishop moves
  def valid_bishop_moves(piece, destination)
    row_diff = (piece[0] - destination[0]).abs
    col_diff = (piece[1] - destination[1]).abs

    return true if row_diff == col_diff

    false
  end

  # Helper method for queen moves
  def valid_queen_moves(piece, destination)
    return true if valid_bishop_moves(piece, destination) || valid_rook_moves(piece, destination)

    false
  end

  # Helper methods for king moves
  def valid_king_moves(piece, destination)
    array = []
    array[0] = piece[0] - destination[0]
    array[1] = piece[1] - destination[1]
    return true if KING_MOVES.any?(array)

    false
  end

  def update_king_position(color, destination)
    if color == white
      @white_king_position = destination[0], destination[1]
    else
      @black_king_position = destination[0], destination[1]
    end
    p @white_king_position
    p @black_king_position
  end
end
