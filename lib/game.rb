# frozen_string_literal: true

require_relative 'player'
require_relative 'rules'
require_relative 'symbols'
require_relative 'moves'
require_relative 'board'
require 'io/console'

# class for controlling game flow
class Game
  include Symbols
  include Moves

  attr_accessor :player1, :player2, :board, :turn
  attr_reader :color_array

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @color_array = [white, black]
    @board = Board.new
    @turn = 0
  end

  def game
    # intro
    # chess_rules = Rules.new
    # chess_rules.rules
    # set_player_name
    # who_goes_first
    # turn = 0
    loop do
      @turn += 1
      board.display_board
      move_arr = move(turn)
      board.update_board(move_arr)
      break if @turn >= 20
    end
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
    piece_and_move = [nil, nil]
    move_array = []
    loop do
      valid_input = get_move(turn, piece_and_move)
      move_array = translate_move_to_grid(piece_and_move)
      valid_move = board.valid_move?(move_array, turn)
      break if valid_input && valid_move
      puts 'Please enter a valid move'
      puts ''
    end

    move_array
  end

  def get_move(turn, piece_and_move)
    loop do
      if turn.odd?
        (puts "#{player1.name}, which piece would you like to move? (Please enter column then row, ex. 'd2')")
      else
        (puts "#{player2.name}, which piece would you like to move? (Please enter column then row, ex. 'd2')")
      end
      piece_and_move[0] = gets.chomp.downcase
      puts 'Where would you like to move that piece?'
      piece_and_move[1] = gets.chomp.downcase
      puts ''
      valid_input = valid_input?(piece_and_move)
      return true if valid_input
      puts "Invalid move! Please enter column then row, ex. 'd2'"
    end
  end

  def translate_move_to_grid(array)
    return nil if array.nil?

    piece_and_destination = [[], []]
    piece = array[0]
    move = array[1]
    piece_and_destination[0] << (8 - piece[1].to_i)
    piece_and_destination[0] << (piece[0].ord - 97)
    piece_and_destination[1] << (8 - move[1].to_i)
    piece_and_destination[1] << (move[0].ord - 97)
    piece_and_destination
  end

  def valid_input?(piece_and_move)
    return false if piece_and_move[0].empty? || piece_and_move[1].empty?

    return true if piece_and_move[0][0].match(/[abcdefgh]/) &&
                   piece_and_move[0][1].to_i.between?(1, 8) &&
                   piece_and_move[1][0].match(/[abcdefgh]/) &&
                   piece_and_move[1][1].to_i.between?(1, 8)

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
