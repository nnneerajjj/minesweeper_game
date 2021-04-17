# frozen_string_literal: true

require_relative '../minesweeper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Minesweeper do
  let(:board_size) { (3..30).to_a.sample }
  let(:level) { %i[easy medium hard].sample }
  let(:game) { Minesweeper.new(board_size, level) }
  let(:mine_board) { game.instance_variable_get(:@mine_board) }

  context '#initialize' do
    it 'creates a minesweeper class instance' do
      expect(game).to be_kind_of(Minesweeper)
    end

    describe '#status' do
      it 'has status still playing' do
        expect { game.status }.to output("Still playing\n").to_stdout
      end
    end

    describe '#display' do
      it 'displays all boxes as hidden' do
        display_board = "\n"

        board_size.times do |_row|
          board_size.times do |_box|
            display_board += "#{Board::HIDDEN}  "
          end
          display_board += "\n"
        end

        expect { game.display }.to output(display_board).to_stdout
      end
    end
  end

  context '#attempt' do
    context 'when coordinates are invalid' do
      it 'displays error message' do
        expect { game.attempt(board_size + 1, board_size) }
          .to output('Invalid coordinate!').to_stdout
      end
    end

    context 'when coordinates are valid' do
      describe 'Step on an empty box' do
        before do
          # Select a box without mine
          @box = random_box(board_size)
          @box = random_box(board_size) while mine?(mine_board.game_board, @box[0], @box[1])

          game.attempt(@box[0], @box[1])

          display_board = game.instance_variable_get(:@display_board)
          @box_value = display_board.game_board[@box[0] - 1][@box[1] - 1]
        end

        it 'has status still playing' do
          expect { game.status }.to output("Still playing\n").to_stdout
        end

        it 'opened box has a valid value' do
          valid_values = (0..8).to_a.map(&:to_s)

          expect(valid_values).to include(@box_value)
        end

        describe '#display' do
          it 'displays opened box with all other boxes as hidden' do
            display_board = "\n"

            (1..board_size).each do |row|
              (1..board_size).each do |col|
                display_board += if row == @box[0] && col == @box[1]
                                   "#{@box_value}  "
                                 else
                                   "#{Board::HIDDEN}  "
                                 end
              end
              display_board += "\n"
            end

            expect { game.display }.to output(display_board).to_stdout
          end
        end
      end

      describe 'Step on a mine' do
        before do
          # Select a box with mine
          box = random_box(board_size)
          box = random_box(board_size) until mine?(mine_board.game_board, box[0], box[1])

          game.attempt(box[0], box[1])
        end

        it 'has status Lost' do
          expect { game.status }.to output("Lost\n").to_stdout
        end
      end

      describe 'Open all empty boxes' do
        before do
          (1..board_size).each do |row|
            (1..board_size).each do |col|
              game.attempt(row, col) unless mine?(mine_board.game_board, row, col)
            end
          end
        end

        it 'has status Won' do
          expect { game.status }.to output("Won\n").to_stdout
        end
      end
    end
  end

  private

  def random_box(board_size)
    row = rand(1..board_size)
    col = rand(1..board_size)
    [row, col]
  end

  def mine?(board, row, col)
    board[row - 1][col - 1] == Board::MINE
  end
end
# rubocop:enable Metrics/BlockLength
