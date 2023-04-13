# frozen_string_literal: true

# module for storing all the valid moves
module Moves
  def pawn_moves(color, row, column, capturing = false)
    if !capturing
      grid[row][column] = grid[row + 1][column]
      grid[row][column] = empty_circle
    # elsif capturing
    #   grid[row][column] = grid[row + 1][column + 1] || grid[row][column] = grid[row + 1][column - 1]
    #   grid[row][column] = empty_circle
    end
  end
end
