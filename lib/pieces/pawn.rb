# frozen_string_literal: true

# Class for pawn pieces
class Pawn
  include Moves

  def pawn_moves(color, piece, destination)
    p 'pawn moves'
    return false if piece.nil? || destination.nil?

    return true if first?(color, piece, destination)
    return true if next_pawn_move(color, piece, destination)
    return true if capturing?(color, piece, destination) &&
                   valid_diagonal?(color, piece, destination)

    puts 'Invalid move! Please enter a valid move for a pawn.'
    false
  end

  # Helper methods for pawn moves
  def first?(color, piece, destination)
    return true if first_move?(color, piece) &&
                   clear_path?(piece, destination) &&
                   one_or_two_ahead?(color, piece, destination)

    false
  end

  def next_pawn_move(color, piece, destination)
    p 'next pawn move'
    return true if !first_move?(color, piece) &&
                   !capturing?(color, piece, destination) &&
                   one_ahead?(color, piece, destination)

    false
  end

  def first_move?(color, piece)
    return true if color == white && piece[0] == 6
    return true if color == black && piece[0] == 1

    false
  end

  def one_or_two_ahead?(color, piece, destination)
    return true if one_or_two_ahead_white(color, piece, destination)
    return true if one_or_two_ahead_black(color, piece, destination)

    false
  end

  def one_or_two_ahead_white(color, piece, destination)
    if color == white &&
       (piece[0] - destination[0] == 1 || piece[0] - destination[0] == 2) &&
       piece[1] == destination[1]
      return true
    end

    false
  end

  def one_or_two_ahead_black(color, piece, destination)
    if color == black &&
       (piece[0] - destination[0] == -1 || piece[0] - destination[0] == -2) &&
       piece[1] == destination[1]
      return true
    end

    false
  end

  def one_ahead?(color, piece, destination)
    if color == white &&
       piece[0] - destination[0] == 1 && piece[1] == destination[1]
      return true
    end

    if color == black &&
       piece[0] - destination[0] == -1 && piece[1] == destination[1]
      return true
    end

    false
  end

  def valid_diagonal?(color, piece, destination)
    if color == white &&
       piece[0] - destination[0] == 1 && move_one_column(piece, destination)
      true
    elsif piece[0] - destination[0] == -1 && move_one_column(piece, destination)
      true
    else
      false
    end
  end

  def move_one_column(piece, destination)
    return true if (piece[1] - destination[1]).abs == 1

    false
  end
end
