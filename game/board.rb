# frozen_string_literal: true

# Game board
class Board
  attr_accessor :size, :game_board
  MINE = '*'
  HIDDEN = 'X'
  EMPTY = 'o'

  def initialize(size)
    @size = size
  end

  def generate(hidden: true)
    value = hidden ? HIDDEN : EMPTY
    @game_board = Array.new(@size) { Array.new(@size, value) }
    self
  end

  def mine?(row, col)
    @game_board[row - 1][col - 1] == MINE
  end

  def plant_mine(row, col)
    @game_board[row - 1][col - 1] = MINE
  end

  def display
    print "\n"
    @game_board.each do |row|
      row.each do |box|
        print "#{box}  "
      end
      print "\n"
    end
  end

  def hidden_boxes_remaining
    @game_board.flatten.select { |box| box == HIDDEN }.length
  end

  def coordinates_invalid?(row, col)
    row < 1 || col < 1 || row > @size || col > @size
  end

  def number_of_adjacent_mines(row, col)
    number_of_adjacent_mines = 0

    ((row - 1)..(row + 1)).each do |adjacent_row|
      ((col - 1)..(col + 1)).each do |adjacent_col|
        next if coordinates_invalid?(adjacent_row, adjacent_col)
        next if (row == adjacent_row) && (col == adjacent_col)

        number_of_adjacent_mines += 1 if mine?(adjacent_row, adjacent_col)
      end
    end

    number_of_adjacent_mines
  end
end
