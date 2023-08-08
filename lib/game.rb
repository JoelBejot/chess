# frozen_string_literal: true

require_relative 'player'

require_relative 'rules'
require_relative 'symbols'
# # require_relative 'moves'
require_relative 'board'
require 'io/console'

# Dir["/home/joelbejot/chess/pieces/*.rb"].each {|file| require file }

# Dir["/path/to/directory/*.rb"].each {|file| require file }

# class for controlling game flow
class Game
  include Symbols
  # include Moves

  # attr_accessor :player1, :player2, :board, :turn, :game_piece, :game_destination, :user_piece, :user_destination
  attr_accessor :player1, :player2, :board

  attr_reader :color_array

  def initialize
    @player1 = Player.new
    @player1.name = 'Player 1'
    @player2 = Player.new
    @player2.name = 'Player 2'
    @color_array = [white, black]
    @board = Board.new
    # @turn = 0
    # @game_piece = []
    # @game_destination = []
    # @user_piece = String.new
    # @user_destination = String.new
  end

  def game
    # intro
    # chess_rules = Rules.new
    # chess_rules.rules
    # set_player_name
    who_goes_first
    board.display_board
    # turn = 0
    # loop do
    #   break if board.checkmate

    #   (puts "#{player1.name}, your king is in check!") if board.white_check
    #   (puts "#{player2.name}, your king is in check!") if board.black_check
    #   @turn += 1
    #   board.display_board
    #   board.display_captured_pieces
    #   move(@turn)
    #   board.update_board(@game_piece, @game_destination)
    #   p "game piece: #{@game_piece}, game destination: #{@game_destination}"


    #   break if board.white_pieces_array[12].nil? || board.black_pieces_array[4].nil? || board.checkmate
    # end
    # turn.odd? ? (puts "#{player1.name} is the winner!") : (puts "#{player2.name} is the winner!")
  end

  def set_player_name
    player1.name = get_player_name(1)
    player2.name = get_player_name(2)
  end

  def get_player_name(num)
    puts "What is Player #{num}'s name?"
    gets.chomp
  end

  # so you get the move from the user, translate that to useful grid elements
  # then, if you are already in check, you need to get out of check
  # so you temporarily create like a proposed move
  # if the proposed move gets you out of check, then you're good to go. If not, loop repeats

  def move(turn)
    move_array = [nil, nil]

    loop do
      valid_input = get_move(turn)

      @game_piece = translate_user_input_to_grid(@user_piece)
      @game_destination = translate_user_input_to_grid(@user_destination)

      if valid_input && board.valid_move?(@game_piece, @game_destination, turn)
        board.update_array_position(@game_piece, @game_destination, @turn)
        break
      end

      puts 'Please enter a valid move'
      puts ''
    end

    move_array
  end

  def get_move(turn)
    loop do
      if turn.odd?
        (puts "#{player1.name}, which piece would you like to move? (Please enter column then row, ex. 'd2')")
      else
        (puts "#{player2.name}, which piece would you like to move? (Please enter column then row, ex. 'd2')")
      end
      @user_piece = gets.chomp.downcase
      puts 'Where would you like to move that piece?'
      @user_destination = gets.chomp.downcase
      puts ''
      return true if valid_input?(@user_piece, @user_destination)

      puts "Invalid move! Please enter column then row, ex. 'd2'"
    end
  end

  def translate_user_input_to_grid(string)
    return nil if string.nil?

    array = [nil, nil]

    array[0] = (8 - string[1].to_i)
    array[1] = (string[0].ord - 97)
    array
  end

  def valid_input?(piece, destination)
    return false if piece.empty? || destination.empty? ||
                    piece.length != 2 || destination.length != 2

    return true if piece[0].match(/[abcdefgh]/) &&
                   piece[1].to_i.between?(1, 8) &&
                   destination[0].match(/[abcdefgh]/) &&
                   destination[1].to_i.between?(1, 8)

    puts 'Invalid move!'
    puts ''
    false
  end

  private

  def intro
    puts 'Introdution to CHESS'
  end

  def who_goes_first
    assign_color
    display_player_color
    player1.color == white ? (puts "#{player1.name} goes first!") : (puts "#{player2.name} goes first!")
  end

  def assign_color
    player1.color = color_array.sample
    player2.color = @player1.color == color_array[0] ? color_array[1] : color_array[0]
  end

  def display_player_color
    puts "#{player1.name} is #{player1.color}."
    puts "#{player2.name} is #{player2.color}."
  end
end
