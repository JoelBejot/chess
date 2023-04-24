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

  def update_board(piece, destination)
    grid[destination[0]][destination[1]] = grid[piece[0]][piece[1]]
    grid[piece[0]][piece[1]] = "|#{empty_circle}|"
  end

  def valid_move?(piece, destination, turn)
    color = turn.odd? ? white : black
    valid = if grid[piece[0]][piece[1]].match(pawn(color))
              pawn_moves(color, piece, destination)
            elsif grid[piece[0]][piece[1]].match(rook(color))
              rook_moves(color, piece, destination)
            elsif grid[piece[0]][piece[1]].match(knight(color))
              knight_moves(color, piece, destination)
            elsif grid[piece[0]][piece[1]].match(bishop(color))
              bishop_moves(color, piece, destination)
            elsif grid[piece[0]][piece[1]].match(queen(color))
              queen_moves(color, piece, destination)
            elsif grid[piece[0]][piece[1]].match(king(color))
              king_moves(color, piece, destination)
            end

    valid
  end

  def check?
    puts "In the check method"
    
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
    if color == white
      grid[6].each_index { |index| grid[6][index] = "|#{pawn(color)}|" }
    else
      grid[1].each_index { |index| grid[1][index] = "|#{pawn(color)}|" }
    end
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
