# frozen_string_literal: true

# class for knight pieces
class Knight
  include Moves
  
  KNIGHT_MOVES = [
    [1, 2], [-1, -2], [-1, 2], [1, -2],
    [2, 1], [-2, -1], [-2, 1], [2, -1]
  ].freeze

  def knight_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = true if grid[destination[0]][destination[1]].match(empty_circle)
    capture = opponent_at_end?(color, destination)

    return true if (clear || capture) && valid_knight_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a knight.'

    false
  end

  def valid_knight_moves(piece, destination)
    array = []
    array[0] = piece[0] - destination[0]
    array[1] = piece[1] - destination[1]
    return true if KNIGHT_MOVES.any?(array)

    false
  end
end
