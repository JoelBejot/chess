# frozen_string_literal: true

require_relative 'player'
require_relative 'rules'
require_relative 'symbols'
require 'io/console'

# class for controlling game flow
class Game
  include Symbols

  attr_accessor :player1, :player2
  attr_reader :color_array

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @color_array = %w[white black]
  end

  def game
    # intro
    # chess_rules = Rules.new
    # chess_rules.rules
    # set_player_name
    # who_goes_first
    puts white
    puts black
  end

  def set_player_name
    player1.name = get_player_name(1)
    player2.name = get_player_name(2)
  end

  def get_player_name(num)
    puts "What is Player #{num}'s name?"
    gets.chomp
  end

  private

  def intro
    puts 'Introdution to CHESS'
  end

  def who_goes_first
    assign_color
    display_player_color
    player1.color == 'white' ? (puts "#{player1.name} goes first!") : (puts "#{player2.name} goes first!")
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
