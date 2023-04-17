# frozen_string_literal: true

require_relative 'symbols'

# class for the chess board
class Board
  include Symbols
  include Enumerable
  include Moves

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { "|#{empty_circle}|" } }
    add_pieces_to_board
  end

  def display_board
    grid.each_with_index do |row, index|
      puts "#{8 - index}: #{row.join('  ')}"
    end
    puts "    #{('a'..'h').to_a.join('    ')}"
    puts ''
  end

  def each
    for grid in @grid do
      return grid
    end
  end

  def update_board(move_arr)
    grid[move_arr[1][0]][move_arr[1][1]] = grid[move_arr[0][0]][move_arr[0][1]]
    grid[move_arr[0][0]][move_arr[0][1]] = "|#{empty_circle}|"
  end

  def valid_move?(move_array, turn)
    starting_row = move_array[0][0]
    ending_row = move_array[1][0]
    starting_column = move_array[0][1]
    ending_column = move_array[1][1]
    color = turn.odd? ? white : black
    valid = false

    # need to add condition so can't capture own piece


    if grid[starting_row][starting_column].match(pawn(color))
      valid = pawn_moves(move_array, color)
    elsif grid[starting_row][starting_column].match(rook(color))
      valid = rook_moves(move_array, color, capturing)
    elsif grid[starting_row][starting_column].match(king(color))
      valid = king_moves(move_array, color, capturing)
    end
    puts "valid = #{valid}"
    valid
  end

  def add_pieces_to_board
    assign_white_pieces
    assign_black_pieces
  end

  def assign_white_pieces
    assign_pawns(white)
    assign_power_pieces(white)
  end

  def assign_black_pieces
    assign_pawns(black)
    assign_power_pieces(black)
  end

  def assign_pawns(color)
    color == white ? grid[6].each_index { |index| grid[6][index] = "|#{pawn(color)}|" } : grid[1].each_index { |index| grid[1][index] = "|#{pawn(color)}|" }
  end

  def assign_power_pieces(color)
    assign_rooks(color)
    assign_knights(color)
    assign_bishops(color)
    assign_kings_and_queens(color)
  end

  def assign_rooks(color)
    if color == white
      grid[7][0] = "|#{rook(color)}|"
      grid[7][7] = "|#{rook(color)}|"
    else
      grid[0][0] = "|#{rook(color)}|"
      grid[0][7] = "|#{rook(color)}|"
    end
  end

  def assign_knights(color)
    if color == white
      grid[7][1] = "|#{knight(color)}|"
      grid[7][6] = "|#{knight(color)}|"
    else
      grid[0][1] = "|#{knight(color)}|"
      grid[0][6] = "|#{knight(color)}|"
    end
  end

  def assign_bishops(color)
    if color == white
      grid[7][2] = "|#{bishop(color)}|"
      grid[7][5] = "|#{bishop(color)}|"
    else
      grid[0][2] = "|#{bishop(color)}|"
      grid[0][5] = "|#{bishop(color)}|"
    end
  end

  def assign_kings_and_queens(color)
    if color == white
      grid[7][3] = "|#{queen(color)}|"
      grid[7][4] = "|#{king(color)}|"
    else
      grid[0][3] = "|#{queen(color)}|"
      grid[0][4] = "|#{king(color)}|"
    end
  end
end

# board = Board.new
# board.display_board
# board.add_pieces_to_board
# board.display_board
