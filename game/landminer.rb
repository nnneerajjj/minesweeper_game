# frozen_string_literal: true

# Lays mines on game board
class Landminer
  attr_accessor :number_of_mines_laid

  def initialize(board_size, level)
    @board_size = board_size
    @level = level.to_sym

    @board = Board.new(@board_size).generate(hidden: false)

    @number_of_mines_to_lay = number_of_mines_to_lay
    @number_of_mines_laid = 0
  end

  def lay_mines
    while @number_of_mines_laid < @number_of_mines_to_lay
      row = rand(1..@board_size)
      col = rand(1..@board_size)

      next if @board.mine?(row, col)

      @board.plant_mine(row, col)

      @number_of_mines_laid += 1
    end

    @board
  end

  private

  def number_of_mines_to_lay
    ((@board_size**2) * mine_ratio).ceil
  end

  def mine_ratio
    case @level

    when :medium
      0.2 # 20%
    when :hard
      0.3 # 30%
    else # default
      @level = :easy
      0.1 # 10%
    end
  end
end
