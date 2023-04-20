# frozen_string_literal: true

# methods in this module all return boolean values - whether or not a given move is a valid one.
module Moves
  # Reader method for determining if pawn move is valid
  def pawn_moves(move_array, color)
    starting_row = move_array[0][0]
    ending_row = move_array[1][0]
    starting_column = move_array[0][1]
    ending_column = move_array[1][1]

    first = first_move?(color, starting_row)
    clear = clear_path?(starting_row, starting_column, ending_row, ending_column)
    capture = capturing?(color, starting_row, starting_column, ending_row, ending_column)

    return true if first && clear && one_or_two_ahead?(color, starting_row, ending_row)
    return true if !first && !capture && clear && one_ahead?(color, starting_row, ending_row)
    return true if capture && valid_diagonal?(color, starting_row, starting_column, ending_row, ending_column)

    p "capture = #{capture}"
    p "valid diagonal = #{valid_diagonal?(color, starting_row, starting_column, ending_row, ending_column)}"

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

  # Helper methods for pawn moves
  def first_move?(color, starting_row)
    return true if color == white && starting_row == 6
    return true if color == black && starting_row == 1

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

  def valid_diagonal?(color, starting_row, starting_column, ending_row, ending_column)
    if color == white &&
       starting_row - ending_row == 1 &&
       (starting_column - ending_column == 1 ||
       starting_column - ending_column == -1)
      true
    elsif color == black &&
          starting_row - ending_row == -1 &&
          (starting_column - ending_column == 1 ||
          starting_column - ending_column == -1)
      true
    else
      false
    end
  end

  # Helper methods for all moves
  def clear_path?(starting_row, starting_column, ending_row, ending_column)
    row_range = get_row_range(starting_row, ending_row)
    column_range = get_column_range(starting_column, ending_column)

    array_length_match(row_range, column_range)
    all_clear?(row_range, column_range, starting_row, ending_row, starting_column, ending_column)
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

  def all_clear?(row_range, column_range, starting_row, ending_row, starting_column, ending_column)
    array = []

    row_range.reverse! if starting_row > ending_row
    column_range.reverse! if starting_column > ending_column
  
    row_range.each_index do |index|
      array[index] = grid[row_range[index]][column_range[index]].match(empty_circle) ? true : false
    end

    array.shift

    return true if array.all?(true)

    false
  end

  def capturing?(color, starting_row, starting_column, ending_row, ending_column)
    row_range = get_row_range(starting_row, ending_row)
    column_range = get_column_range(starting_column, ending_column)

    array_length_match(row_range, column_range)
    p opponent_at_end?(color, row_range, column_range, starting_row, ending_row, starting_column, ending_column)
  end

  def opponent_at_end?(color, row_range, column_range, starting_row, ending_row, starting_column, ending_column)
    array = []

    row_range.reverse! if starting_row > ending_row
    column_range.reverse! if starting_column > ending_column

    p "opponent row range = #{row_range}"
    p "opponent column range = #{column_range}"
   
    p "color = #{color}"

    if color == white
      row_range.each_index do |index|
        p "grid[row_range[index]][column_range[index]].match(empty_circle) #{grid[row_range[index]][column_range[index]].match(empty_circle)}"
        p "any black symbols? #{grid[row_range[index]][column_range[index]].include?(symbols_array(black).to_s)}"
        p "any black symbols? #{symbols_array(white).select { |piece| piece.match(grid[row_range[index]][column_range[index]])}}"
        array[index] = if !grid[row_range[index]][column_range[index]].match(empty_circle) 
                          # grid[row_range[index]][column_range[index]].match(symbols_array(black))
                         true
                       else
                         false
                       end
      end
    else
      row_range.each_index do |index|
        p "grid[row_range[index]][column_range[index]].match(empty_circle) #{grid[row_range[index]][column_range[index]].match(empty_circle)}"
        p "#{symbols_array(black)}"
        array[index] = if !grid[row_range[index]][column_range[index]].match(empty_circle) 
                          # grid[row_range[index]][column_range[index]].match(symbols_array(white))
                         true
                       else
                         false
                       end
      end
    end

    p "opponent at end before shift/pop = #{array}"

    array.shift

    p "opponent at end after = #{array}"

    return true if array.all?(true)

    false

  end

  # def empty_circle_array(row_range, column_range)
  #   array = [false]

  #   p "row range = #{row_range}"
  #   p "column range = #{column_range}"

  #   row_range.each_index do |index|
  #     array[index] = grid[row_range[index]][column_range[index]].match(empty_circle) ? true : false
  #   end
  #   array
  # end

  # def change_array_end(array, color, row_range, column_range)
  #   p "array = #{array}"
  #   p "color = #{color}"
  #   p "row range = #{row_range}"
  #   p "column range = #{column_range}"
  #   p "any black symbols? = #{symbols_array(black).any? { |symbol| grid[row_range[-1]][column_range[-1]].include?(symbol) }}"
    
  #   if color == white && symbols_array(black).any? # { |symbol| grid[row_range[-1]][column_range[-1]].include?(symbol) }
  #     array[-1] = true
  #   elsif color == black && symbols_array(white).any? # { |symbol| grid[row_range[-1]][column_range[-1]].include?(symbol) }
  #     array[-1] = true
  #   else
  #     array[-1] = false
  #   end
  #   array
  # end



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
