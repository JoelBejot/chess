# frozen_string_literal: true

require_relative 'symbols'
require_relative 'moves'

# class for the chess board
class Board
  include Symbols
  include Enumerable
  include Moves

  attr_accessor :grid, :white_pieces_array, :black_pieces_array, 
    :captured_white_pieces, :captured_black_pieces, :white_check, :black_check

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

  def each
    for grid in @grid do
      return grid
    end
  end

  def update_board(piece, destination)
    grid[destination[0]][destination[1]] = grid[piece[0]][piece[1]]
    grid[piece[0]][piece[1]] = "|#{empty_circle}|"
  end

  # if color == white && capturing?(color, piece, destination)
  #   @captured_black_pieces << grid[destination[0]][destination[1]][1..-2]
  #   p @captured_black_pieces.join(', ')
  # elsif color == black && capturing?(color, piece, destination)
  #   @captured_white_pieces << grid[destination[0]][destination[1]][1..-2]
  #   p @captured_white_pieces.join(', ')
  # end

  # it's valid move if the following conditions are true
  # - the piece can make that move
  # - if you are in check, that move gets you out of check
  def valid_move?(piece, destination, turn)
    p 'Im in the valid move method'
    p "piece, destination, turn = #{piece}, #{destination}, #{turn}"

    return false if piece.nil? || destination.nil?

    temp_array = []
    temp_array = if turn.odd?
                   update_temp_array(@white_pieces_array, @game_piece, @game_destination)
                 elsif turn.even?
                   update_temp_array(@black_pieces_array, @game_piece, @game_destination)
                 end


    p am_i_in_check = check?(temp_array, turn + 1)

    color = turn.odd? ? white : black
    # temp_array = []

    # if white_check
    #   temp_array = board.update_temp_array(board.white_pieces_array, @game_piece, @game_destination)
    #   p "temp array: #{temp_array}"
    #   # next if board.still_in_check?(temp_array, turn)
    # elsif black_check
    #   temp_array = update_temp_array(board.black_pieces_array, @game_piece, @game_destination)
    #   p "temp array: #{temp_array}"
    #   # next if board.still_in_check?(temp_array, turn)
    # end
    move_the_piece = move_the_piece?(color, piece, destination)

    if turn.odd?
      p @black_check = check?(turn)
    elsif turn.even?
      p @white_check = check?(turn)
    end

    return true if move_the_piece
  end

  def move_the_piece?(color, piece, destination)
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
    # return if @white_pieces_array.index(piece).nil? || @black_pieces_array.index(piece).nil?

    if turn.odd?
      @white_pieces_array[@white_pieces_array.index(piece)] = destination
      white_destination_index = @white_pieces_array[@white_pieces_array.index(destination)]
      @black_pieces_array[index] = nil if @black_pieces_array.any?(white_destination_index)
    elsif turn.even?
      @black_pieces_array[@black_pieces_array.index(piece)] = destination
      black_destination_index = @black_pieces_array[@black_pieces_array.index(destination)]
      @white_pieces_array[index] = nil if @white_pieces_array.any?(black_destination_index)
    end
  end

  def update_temp_array(array, piece, destination)
    array[array.index(piece)] = destination
    array
  end

  def display_captured_pieces
    puts "Captured black pieces: #{captured_black_pieces.join(', ')}" unless captured_black_pieces.empty?
    puts "Captured white pieces: #{captured_white_pieces.join(', ')}" unless captured_white_pieces.empty?
  end

  # Update to see if any piece from symbols_array can reach king with valid_move?

  def check?(array, turn)
    p "in check method"

    p "white: #{white_king_position}, black:#{black_king_position}"
    check_array = []
    if turn.odd?
      white_king_position = array[12]
      array.each do |el|
        # p valid_check?(el, black_king_position, turn)
        check_array << valid_check?(el, black_king_position, turn)
      end
    elsif turn.even?
      black_king_position = array[4]
      array.each do |el|
        # p valid_check?(el, white_king_position, turn)
        check_array << valid_check?(el, white_king_position, turn)
      end
    end
    p "check array: #{check_array}"
    p "in check? white: #{@white_check}, black: #{@black_check}"
    check_array.any?(true) ? true : false
  end

  def valid_check?(piece, destination, turn)
    p "piece: #{piece}, destination: #{destination}, turn: #{turn}"
    return false if piece.nil? || destination.nil?

    color = turn.odd? ? white : black

    move_the_piece?(color, piece, destination)
  end

  def checkmate
    false
  end

  # def still_in_check?(temp_array, turn)
  #   p "in still_in_check method"

  #   white_king_position = white_pieces_array[12]
  #   black_king_position = black_pieces_array[4]
  #   p "white: #{white_king_position}, black:#{black_king_position}"
  #   check_array = []
  #   if turn.odd?
  #     black_pieces_array.each do |el|
  #       # p valid_check?(el, black_king_position, turn)
  #       check_array << valid_check?(el, white_king_position, turn + 1)
  #     end
  #   elsif turn.even?
  #     white_pieces_array.each do |el|
  #       # p valid_check?(el, white_king_position, turn)
  #       check_array << valid_check?(el, black_king_position, turn + 1)
  #     end
  #   end
  #   p "check array: #{check_array}"
  #   check_array.any?(true) ? true : false
  # end



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
