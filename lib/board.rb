# frozen_string_literal: true

require_relative 'symbols'

# class for the chess board
class Board
  include Symbols
  include Enumerable
  include Moves

  attr_accessor :grid, :white_pieces_array, :black_pieces_array

  def initialize
    @grid = Array.new(8) { Array.new(8) { "|#{empty_circle}|" } }
    add_pieces_to_board
    @white_pieces_array = [
      [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7],
      [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]
    ]
    @black_pieces_array = [
      [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
      [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]
    ]
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
    p 'Im in the valid move method'
    return false if piece.nil? || destination.nil?

    p "piece, destination, turn = #{piece}, #{destination}, #{turn}"
    color = turn.odd? ? white : black
    if grid[piece[0]][piece[1]].match(pawn(color))
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
  end

  def update_array_position(piece, destination, turn)
    puts "I'm in the update array position method"
    p "white array #{white_pieces_array}"
    p "black array #{black_pieces_array}"
    p "piece, destination = #{piece}, #{destination}"

    if turn.odd?
      p 'white truthy'
      @white_pieces_array[@white_pieces_array.index(piece)] = destination
    else
      p 'black truthy'
      @black_pieces_array[@black_pieces_array.index(piece)] = destination
    end

    p "white array #{white_pieces_array}"
    p "black array #{black_pieces_array}"
    
  end

  # Update to see if any piece from symbols_array can reach king with valid_move?

  # def check?(piece, turn)
  #   return false if piece.nil?

  #   # array = []

  #   # grid.each do |row|
  #   #   row.each do |spot|
  #   #     if white_symbols_array.any? { |el| array << [row, spot] }
  #   #       # p "array = #{array}"
  #   #     end
  #   #   end
  #   # end

  #   check = turn.odd? ? valid_move?(piece, @black_king_position, turn) : valid_move?(piece, @white_king_position, turn)
  #   puts "You're in check!" if check
  #   check
  # end

  def checkmate

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
    color == white ? assign_white_rooks(color) : assign_black_rooks(color)
  end

  def assign_white_rooks(color)
    grid[7][0] = "|#{rook(color)}|"
    grid[7][7] = "|#{rook(color)}|"
  end

  def assign_black_rooks(color)
    grid[0][0] = "|#{rook(color)}|"
    grid[0][7] = "|#{rook(color)}|"
  end

  def assign_knights(color)
    color == white ? assign_white_knights(color) : assign_black_knights(color)
  end

  def assign_white_knights(color)
    grid[7][1] = "|#{knight(color)}|"
    grid[7][6] = "|#{knight(color)}|"
  end

  def assign_black_knights(color)
    grid[0][1] = "|#{knight(color)}|"
    grid[0][6] = "|#{knight(color)}|"
  end

  def assign_bishops(color)
    color == white ? assign_white_bishops(color) : assign_black_bishops(color)
  end

  def assign_white_bishops(color)
    grid[7][2] = "|#{bishop(color)}|"
    grid[7][5] = "|#{bishop(color)}|"
  end

  def assign_black_bishops(color)
    grid[0][2] = "|#{bishop(color)}|"
    grid[0][5] = "|#{bishop(color)}|"
  end

  def assign_kings_and_queens(color)
    color == white ? assign_white_kq(color) : assign_black_kq(color)
  end

  def assign_white_kq(color)
    grid[7][3] = "|#{queen(color)}|"
    grid[7][4] = "|#{king(color)}|"
  end

  def assign_black_kq(color)
    grid[0][3] = "|#{queen(color)}|"
    grid[0][4] = "|#{king(color)}|"
  end
end
