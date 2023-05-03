# frozen_string_literal: true

# class for bishop moves
class Bishop
  include Moves
  
  def bishop_moves(color, piece, destination)
    return false if piece.nil? || destination.nil?

    clear = clear_path?(piece, destination)
    capture = capturing?(color, piece, destination)

    return true if clear && valid_bishop_moves(piece, destination)
    return true if capture && valid_bishop_moves(piece, destination)

    puts 'Invalid move! Please enter a valid move for a bishop.'

    false
  end

  def valid_bishop_moves(piece, destination)
    row_diff = (piece[0] - destination[0]).abs
    col_diff = (piece[1] - destination[1]).abs

    return true if row_diff == col_diff

    false
  end
end
