# frozen_string_literal: true

# class for queen moves
class Queen
  include Moves

  def queen_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_queen_moves(piece, destination)
    return true if capture && valid_queen_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a queen.'

    false
  end

  def valid_queen_moves(piece, destination)
    return true if valid_bishop_moves(piece, destination) || valid_rook_moves(piece, destination)

    false
  end
end
