# frozen_string_literal: true

# class for rook pieces
class Rook
  include Moves

  def rook_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_rook_moves(piece, destination)
    return true if capture && valid_rook_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a rook.'
    false
  end

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
end
