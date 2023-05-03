# frozen_string_literal: true

# class for king moves
class King
  include Moves

  KING_MOVES = [
    [0, 1], [0, -1], [1, 0], [-1, 0],
    [1, 1], [1, -1], [-1, 1], [-1, -1]
  ].freeze

  def king_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_king_moves(piece, destination)
    return true if capture && valid_king_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a king.'

    false
  end

  def valid_king_moves(piece, destination)
    array = []
    array[0] = piece[0] - destination[0]
    array[1] = piece[1] - destination[1]
    return true if KING_MOVES.any?(array)

    false
  end

  # def update_king_position(color, destination)
  #   if color == white
  #     @white_king_position = destination[0], destination[1]
  #   else
  #     @black_king_position = destination[0], destination[1]
  #   end
  #   p @white_king_position
  #   p @black_king_position
  # end
end
