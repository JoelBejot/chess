# frozen_string_literal: true

require_relative 'player'
require_relative 'rules'
require_relative 'symbols'
# require_relative 'moves'
require_relative 'board'
require 'io/console'

Dir["/home/joelbejot/chess/pieces/*.rb"].each {|file| require file }

# Dir["/path/to/directory/*.rb"].each {|file| require file }

# class for controlling game flow
class Game
  include Symbols
  include Moves

  attr_accessor :player1, :player2, :board, :turn, :game_piece, :game_destination, :user_piece, :user_destination
  attr_reader :color_array

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @color_array = [white, black]
    @board = Board.new
    @turn = 0
    @game_piece = []
    @game_destination = []
    @user_piece = String.new
    @user_destination = String.new
  end

  def game
    # intro
    # chess_rules = Rules.new
    # chess_rules.rules
    # set_player_name
    # who_goes_first
    # turn = 0
    loop do
      # board.checkmate?
      # break if board.checkmate
      @turn += 1
      board.display_board
      move(@turn)
      board.update_board(@game_piece, @game_destination)
      board.update_array_position(@game_piece, @game_destination, @turn)
      in_check = board.check?(@game_destination, @turn)
      p "in check? #{in_check}"
      break if @turn >= 20
    end
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

  def move(turn)
    move_array = [nil, nil]

    loop do
      valid_input = get_move(turn)

      @game_piece = translate_user_input_to_grid(@user_piece)
      @game_destination = translate_user_input_to_grid(@user_destination)

      break if valid_input && board.valid_move?(@game_piece, @game_destination, turn)

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
