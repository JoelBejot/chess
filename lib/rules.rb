# frozen_string_literal: true

# class for displaying chess rules
class Rules
  def rules
    puts 'Would you like to see the rules? (y/n)'
    answer = $stdin.getch
    return if answer == 'n'

    chess_rules =  <<~HEREDOC

      This version of chess is a two player, PvP game.

      1. Object of the game
      The object of the game is to capture the opponent's king, by way of "checkmate,"
        when the king can no longer make a move where it would be uncaptured.

      2. Board setup
      Each player is given the same pieces.
      The second row consists entirely of pawns, while the first row constists of several different pieces:
        The pawn can only move forward one square, except:
          a) it can move forward two squares on it's first move.
          b) it can only capture pieces one square forward diagonally.
        The rook, or castle, can move left, right, up, or down as far as the player would like it to move.
        The knight has a unique move - it moves over two and up one, or over one and up two, in any combination.
        The bishop can move in any diagonal as far as the player would like.
        The queen combines the moves of the rook and the bishop, and is a very powerful piece.
        The king moves only one square, up, down, left, right, or diagonally.
        --special note: Only the knight can jump over pieces and land on any free square.
          All others cannot pass through either their own or the opponent's pieces.

      3. Capturing pieces
        You can "capture" the opponent's pieces by moving your piece into their space.
        This removes their piece from the board, making your quest to capture the king easier!
        As noted above, pawns can only capture in the forward-diagonal motion.
        All other pieces capture in their usual way of travel.
      
      4. Check and checkmate
        When the opponent's king is threatened by one of your pieces, that is called "check."
        On the opponent's next turn, they must either move their king out of harm's way, 
          put a piece between the king and the threatening piece, if possible, 
          or capture the threatening piece.
        If the opponent cannot free their king from "check," then that is called "checkmate,"
          and the game is over.

      5. Special moves
        Special moves will be developed in future updates
        a) promote pawn
        b) en passant
        c) castling

      6. Who goes first?
        "White" goes first, and the computer will choose who goes first randomly.

      That's it!
      Enjoy the game!

    HEREDOC
    puts chess_rules
  end
end
