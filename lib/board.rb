# frozen_string_literal: true

require_relative 'symbols'
require_relative 'moves'

# class for the chess board
class Board
  include Symbols
  include Enumerable
  include Moves

  attr_accessor :grid, :temp_grid, :white_pieces_array, :black_pieces_array,
                :captured_white_pieces, :captured_black_pieces, :white_check, :black_check

  def initialize
    @grid = Array.new(8) { Array.new(8) { "|#{empty_circle}|" } }
    add_pieces_to_board(@grid)
    # add_pieces_to_board(@temp_grid)
    @white_pieces_array = [
      [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7],
      [7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]
    ]
    @black_pieces_array = [
      [0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
      [1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]
    ]
    @captured_white_pieces = []
    @captured_black_pieces = []
    @white_check = false
    @black_check = false
  end

  def display_board
    grid.each_with_index do |row, index|
      puts "#{8 - index}: #{row.join('  ')}"
    end
    puts "    #{('a'..'h').to_a.join('    ')}"
    puts ''
  end

  def update_board(board, piece, destination)
    board[destination[0]][destination[1]] = board[piece[0]][piece[1]]
    board[piece[0]][piece[1]] = "|#{empty_circle}|"

    board
  end

  def valid_move?(piece, destination, turn)
    return false if piece.nil? || destination.nil?

    temp_grid = []
    @grid.each { |el| temp_grid << el.dup }

    temp_grid = update_board(temp_grid, piece, destination)
    p "temp grid: #{temp_grid}"

    p "@white_check: #{@white_check}"
    p "@black_check: #{@black_check}"

    color = turn.odd? ? white : black

    if turn.odd? && white_check
      temp_array = []
      @white_pieces_array.each { |el| temp_array << el.dup }
      temp_array[temp_array.index(piece)] = destination
      temp_grid[destination[0]][destination[1]] = temp_grid[piece[0]][piece[1]]
      temp_grid[piece[0]][piece[1]] = "|#{empty_circle}|"
      # update_temp_array(temp_array, piece, destination)
      p "still in check? #{still_in_check?(temp_grid, black_pieces_array, temp_array, turn + 1)}"
      @white_check = false unless still_in_check?(temp_grid, black_pieces_array, temp_array, turn + 1)
      p "@white check: #{@white_check}"

      return false if @white_check

    elsif turn.even? && black_check
      temp_array = []
      @black_pieces_array.each { |el| temp_array << el.dup }
      temp_array[temp_array.index(piece)] = destination
      temp_grid[destination[0]][destination[1]] = temp_grid[piece[0]][piece[1]]
      temp_grid[piece[0]][piece[1]] = "|#{empty_circle}|"
      # update_temp_array(temp_array, piece, destination)
      p "still in check? #{still_in_check?(temp_grid, white_pieces_array, temp_array, turn + 1)}"
      @black_check = false unless still_in_check?(temp_grid, white_pieces_array, temp_array, turn + 1)
      p "@black_check #{@black_check}"

      return false if @black_check

    end

    p "@grid: #{@grid}"
    p "color: #{color}, piece: #{piece}, destination: #{destination}"
    p "move the piece: #{move_the_piece?(@grid, color, piece, destination)}"
    return true if move_the_piece?(@grid, color, piece, destination)

    false
  end

  def still_in_check?(temp_grid, attacker_array, defender_array, turn)
    p "attacker array: #{attacker_array}"
    p "defender array: #{defender_array}"

    check_array = []

    if turn.odd?
      attacker_array.each do |el|
        p "temp valid check: #{temp_valid_check?(temp_grid, el, defender_array[4], turn)}"
        p "el: #{el}, defender array[4]: #{defender_array[4]}"
        check_array << temp_valid_check?(temp_grid, el, defender_array[4], turn)
        # @white_check = check_array.any?(true) ? true : false
      end
    elsif turn.even?
      attacker_array.each do |el|
        p "temp valid check: #{temp_valid_check?(temp_grid, el, defender_array[12], turn)}"
        check_array << temp_valid_check?(temp_grid, el, defender_array[12], turn)
        # @black_check = check_array.any?(true) ? true : false
      end
    end

    p "check array: #{check_array}"
    check_array.any?(true) ? true : false
  end

  def temp_valid_check?(temp_grid, piece, destination, turn)
    return false if piece.nil? || destination.nil?

    color = turn.odd? ? white : black
    move_the_piece?(temp_grid, color, piece, destination)
  end

  def move_the_piece?(board, color, piece, destination)
    p "color #{color}"
    p "board[piece[0]][piece[1]] #{board[piece[0]][piece[1]]}"
    p "board[piece[0]][piece[1]].match((color)) #{board[piece[0]][piece[1]].match((color))}"

    p "white symbols match with any #{white_symbols_array.any?(board[piece[0]][piece[1]])}"
    p "white symbols array #{white_symbols_array}"
    p "white symbols #{white_symbols_array.any?(pawn(color))}"



    if board[piece[0]][piece[1]].match(pawn(color))
      p pawn_moves(board, color, piece, destination)
      return pawn_moves(board, color, piece, destination)
    elsif board[piece[0]][piece[1]].match(rook(color))
      rook_moves(board, color, piece, destination)
    elsif board[piece[0]][piece[1]].match(knight(color))
      knight_moves(board, color, piece, destination)
    elsif board[piece[0]][piece[1]].match(bishop(color))
      bishop_moves(board, color, piece, destination)
    elsif board[piece[0]][piece[1]].match(queen(color))
      queen_moves(board, color, piece, destination)
    elsif board[piece[0]][piece[1]].match(king(color))
      king_moves(board, color, piece, destination)
    end

    false
  end

  def temp_move_the_piece?(temp_grid, color, piece, destination)
    p "color: #{color}, piece: #{piece}, destination: #{destination}"
    # puts "temp_grid #{temp_grid}"
    if temp_grid[piece[0]][piece[1]].match(pawn(color))
      pawn_moves(temp_grid, color, piece, destination)
    elsif temp_grid[piece[0]][piece[1]].match(rook(color))
      rook_moves(temp_grid, color, piece, destination)
    elsif temp_grid[piece[0]][piece[1]].match(knight(color))
      knight_moves(temp_grid, color, piece, destination)
    elsif temp_grid[piece[0]][piece[1]].match(bishop(color))
      bishop_moves(temp_grid, color, piece, destination)
    elsif temp_grid[piece[0]][piece[1]].match(queen(color))
      queen_moves(temp_grid, color, piece, destination)
    elsif temp_grid[piece[0]][piece[1]].match(king(color))
      king_moves(temp_grid, color, piece, destination)
    end
  end

  def check?(attacker_array, defender_array, turn)
    check_array = []

    if turn.odd?
      attacker_array.each do |el|
        check_array << valid_check?(el, defender_array[4], turn)
      end
    else
      attacker_array.each do |el|
        check_array << valid_check?(el, defender_array[12], turn)
      end
    end

    check_array.any?(true) ? true : false
  end

  def valid_check?(piece, destination, turn)
    return false if piece.nil? || destination.nil?

    color = turn.odd? ? white : black
    move_the_piece?(@grid, color, piece, destination)
  end

  def update_array_position(piece, destination, turn)
    if turn.odd?
      @white_pieces_array[@white_pieces_array.index(piece)] = destination
      white_destination_index = @white_pieces_array[@white_pieces_array.index(destination)]
      if @black_pieces_array.any?(white_destination_index)
        @black_pieces_array[@black_pieces_array.index(white_destination_index)] = nil
      end
    elsif turn.even?
      @black_pieces_array[@black_pieces_array.index(piece)] = destination
      black_destination_index = @black_pieces_array[@black_pieces_array.index(destination)]
      if @white_pieces_array.any?(black_destination_index)
        @white_pieces_array[@white_pieces_array.index(black_destination_index)] = nil
      end
    end
  end

  def update_temp_array(array, piece, destination)
    p "update temp array array: #{array}"
    array[array.index(piece)] = destination
    array
  end

  def display_captured_pieces
    puts "Captured black pieces: #{captured_black_pieces.join(', ')}" unless captured_black_pieces.empty?
    puts "Captured white pieces: #{captured_white_pieces.join(', ')}" unless captured_white_pieces.empty?
  end

  def checkmate
    false
  end

  def add_pieces_to_board(board)
    assign_white_pieces(board)
    assign_black_pieces(board)
  end

  def assign_white_pieces(board)
    assign_pawns(board, white)
    assign_power_pieces(board, white)
  end

  def assign_black_pieces(board)
    assign_pawns(board, black)
    assign_power_pieces(board, black)
  end

  def assign_pawns(board, color)
    if color == white
      grid[6].each_index { |index| board[6][index] = "|#{pawn(color)}|" }
    else
      grid[1].each_index { |index| board[1][index] = "|#{pawn(color)}|" }
    end
  end

  def assign_power_pieces(board, color)
    assign_rooks(board, color)
    assign_knights(board, color)
    assign_bishops(board, color)
    assign_kings_and_queens(board, color)
  end

  def assign_rooks(board, color)
    color == white ? assign_white_rooks(board, color) : assign_black_rooks(board, color)
  end

  def assign_white_rooks(board, color)
    board[7][0] = "|#{rook(color)}|"
    board[7][7] = "|#{rook(color)}|"
  end

  def assign_black_rooks(board, color)
    board[0][0] = "|#{rook(color)}|"
    board[0][7] = "|#{rook(color)}|"
  end

  def assign_knights(board, color)
    color == white ? assign_white_knights(board, color) : assign_black_knights(board, color)
  end

  def assign_white_knights(board, color)
    board[7][1] = "|#{knight(color)}|"
    board[7][6] = "|#{knight(color)}|"
  end

  def assign_black_knights(board, color)
    board[0][1] = "|#{knight(color)}|"
    board[0][6] = "|#{knight(color)}|"
  end

  def assign_bishops(board, color)
    color == white ? assign_white_bishops(board, color) : assign_black_bishops(board, color)
  end

  def assign_white_bishops(board, color)
    board[7][2] = "|#{bishop(color)}|"
    board[7][5] = "|#{bishop(color)}|"
  end

  def assign_black_bishops(board, color)
    board[0][2] = "|#{bishop(color)}|"
    board[0][5] = "|#{bishop(color)}|"
  end

  def assign_kings_and_queens(board, color)
    color == white ? assign_white_kq(board, color) : assign_black_kq(board, color)
  end

  def assign_white_kq(board, color)
    board[7][3] = "|#{queen(color)}|"
    board[7][4] = "|#{king(color)}|"
  end

  def assign_black_kq(board, color)
    board[0][3] = "|#{queen(color)}|"
    board[0][4] = "|#{king(color)}|"
  end
end
