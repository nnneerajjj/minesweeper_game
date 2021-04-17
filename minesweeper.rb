# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

Figaro.application = Figaro::Application.new(
  environment: ENV['FIGARO_ENV'] || 'development',
  path: File.expand_path('config/application.yml', __dir__)
)

Figaro.load
Figaro.require_keys('DEBUG')

# require File.expand_path('application.rb', __dir__)
Dir[File.join(__dir__, 'lib', '*.rb')].sort.each { |file| require file }
Dir[File.join(__dir__, 'game', '*.rb')].sort.each { |file| require file }

# Minesweeper game
class Minesweeper
  STATUSES = %i[still_playing won lost].freeze

  def initialize(size, level)
    board_size = size.between?(3, 30) ? size : 3
    @display_board = Board.new(board_size).generate

    landminer = Landminer.new(board_size, level)
    @mine_board = landminer.lay_mines
    @number_of_mines_laid = landminer.number_of_mines_laid

    @current_status = STATUSES.first
  end

  def inspect
    Figaro.env.debug.to_s == 'true' ? super : display
  end

  def display
    @display_board.display
  end

  def status
    puts @current_status.to_s.humanize
  end

  def attempt(row, col)
    if !status_still_playing?
      puts 'Game end'
    elsif @display_board.coordinates_invalid?(row, col)
      print 'Invalid coordinate!'
    else
      open_box(row, col)
      evaluate_result
      declare_result
      display
    end
  end

  private

  STATUSES.each do |status|
    define_method(:"status_#{status}?") do |*_args|
      status == @current_status
    end
  end

  def open_box(row, col)
    hidden_box = @mine_board.game_board[row - 1][col - 1]

    @display_board.game_board[row - 1][col - 1] = case hidden_box
                                                  when Board::MINE
                                                    @current_status = :lost
                                                    Board::MINE
                                                  when Board::EMPTY
                                                    @mine_board.number_of_adjacent_mines(row, col).to_s
                                                  end
  end

  def evaluate_result
    @current_status = :won if @display_board.hidden_boxes_remaining == @number_of_mines_laid
  end

  def declare_result
    case @current_status
    when :lost
      print 'BOOOOM!'
      @mine_board.display
    when :won
      print 'WON!'
      @mine_board.display
    end
  end
end
