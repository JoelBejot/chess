# frozen_string_literal: true

# class for the chess board
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { |num| "|#{num + 1}|" } }
  end

  def display_board
    @grid.each_with_index do |row, index|
      puts "#{index + 1}: #{row.join(' ')}"
    end
    puts "    #{('a'..'h').to_a.join('   ')}"
  end
end

board = Board.new
board.display_board
