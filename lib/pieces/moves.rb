# frozen_string_literal: true

# methods in this module all return boolean values - whether or not a given move is a valid one.
module Moves
  # Helper methods for all moves

  def white
    "\u{25A1}"
  end

  def black
    "\u{25A0}"
  end
  
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
    row_range = reverse_rows(row_range, piece, destination)
    column_range = reverse_columns(column_range, piece, destination)
    array = build_spaces_array(row_range, column_range, array)
    array.shift

    return true if array.all?(true) || array.nil?

    false
  end

  def reverse_rows(row_range, piece, destination)
    row_range.reverse! if piece[0] > destination[0]
    row_range
  end

  def reverse_columns(column_range, piece, destination)
    column_range.reverse! if piece[1] > destination[1]
    column_range
  end

  def build_spaces_array(row_range, column_range, array)
    row_range.each_index do |index|
      array[index] = grid[row_range[index]][column_range[index]].match(empty_circle) ? true : false
    end
    array
  end

  def capturing?(color, piece, destination)
    p "capturing method"
    row_range = get_row_range(piece[0], destination[0])
    column_range = get_column_range(piece[1], destination[1])
    array_length_match(row_range, column_range)
    clear = clear_for_capture(row_range, column_range, piece, destination)

    return true if clear && opponent_at_end?(color, destination)

    false
  end

  def clear_for_capture(row_range, column_range, piece, destination)
    if piece[0] > destination[0]
      all_clear?(row_range[1..-1], column_range[1..-1], piece, destination)
    else
      all_clear?(row_range[0..-2], column_range[0..-2], piece, destination)
    end
  end

  def opponent_at_end?(color, destination)
    array = []

    array[0] = if (color == white && any_black_symbols?(destination)) ||
                  any_white_symbols?(destination)
                 true
               else
                 false
               end

    return true if array[0] == true

    false
  end

  def any_black_symbols?(destination)
    black_symbols_array.any? { |el| el == grid[destination[0]][destination[1]][1..-2] }
  end

  def any_white_symbols?(destination)
    white_symbols_array.any? { |el| el == grid[destination[0]][destination[1]][1..-2] }
  end

  def all_empty_cirles(array_of_squares)
    true_array = []
    array_of_squares.each { |coord| true_array << grid[coord[0]][coord[1]].match(empty_circle) ? true : false }
    true_array
  end
end