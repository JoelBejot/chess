# frozen_string_literal: true

# module for all the different symbols needed for the game
module Symbols
  def white
    "\u{25A1}"
  end

  def black
    "\u{25A0}"
  end

  def pawn(color)
    color == 'white' ? (return "\u{2659}") : (return "\u{265F}")
  end

  def rook(color)
    color == 'white' ? (return "\u{2656}") : (return "\u{265C}")
  end

  def knight(color)
    color == 'white' ? (return "\u{2658}") : (return "\u{265E}")
  end

  def bishop(color)
    color == 'white' ? (return "\u{2657}") : (return "\u{265D}")
  end

  def queen(color)
    color == 'white' ? (return "\u{2655}") : (return "\u{265B}")
  end

  def king(color)
    color == 'white' ? (return "\u{2654}") : (return "\u{265A}")
  end
end
