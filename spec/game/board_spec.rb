# frozen_string_literal: true

require_relative '../../minesweeper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Board do
  let(:board_size) { (3..30).to_a.sample }
  let(:board) { Board.new(board_size) }

  describe '#initialize' do
    it 'creates a Board class instance' do
      expect(board).to be_kind_of(Board)
    end

    it 'sets the size attribute' do
      expect(board.size).to be(board_size)
    end
  end

  describe '#coordinates_invalid' do
    it 'returns false when coordinates are valid' do
      expect(board.coordinates_invalid?(1, board_size)).to be false
    end

    it 'returns true when coordinates are invalid' do
      expect(board.coordinates_invalid?(0, board_size)).to be true
    end
  end

  context 'display board' do
    let(:display_board) { Board.new(board_size).generate }

    describe '#generate' do
      it 'creates a Board class instance' do
        expect(display_board).to be_kind_of(Board)
      end
    end

    describe '#display' do
      it 'displays all boxes as hidden' do
        output = "\n"

        board_size.times do |_row|
          board_size.times do |_box|
            output += "#{Board::HIDDEN}  "
          end
          output += "\n"
        end

        expect { display_board.display }.to output(output).to_stdout
      end
    end

    describe '#hidden_boxes_remaining' do
      before do
        # Open a box
        box = random_box(board_size)
        display_board.game_board[box[0] - 1][box[1] - 1] = rand(0..8)
      end

      it 'returns correct number of hidden boxes' do
        expect(display_board.hidden_boxes_remaining).to eq((board_size * board_size) - 1)
      end
    end
  end

  context 'mine board' do
    let(:mine_board) { Board.new(board_size).generate(hidden: false) }
    let(:box) { random_box(board_size) }

    describe '#generate' do
      it 'creates a Board class instance' do
        expect(mine_board).to be_kind_of(Board)
      end
    end

    describe '#plant_mine' do
      before do
        mine_board.plant_mine(box[0], box[1])
      end

      it 'successfully plants a mine' do
        expect(mine_board.mine?(box[0], box[1])).to be true
      end
    end

    describe '#mine?' do
      before do
        mine_board.plant_mine(box[0], box[1])
      end

      it 'successfully detects a mine' do
        expect(mine_board.mine?(box[0], box[1])).to be true
      end
    end

    describe '#number_of_adjacent_mines' do
      before do
        mine_board.plant_mine(1, 1)
        mine_board.plant_mine(1, 3)
        mine_board.plant_mine(3, 1)
        mine_board.plant_mine(3, 3)
      end

      it 'returns correct number of mines' do
        expect(mine_board.number_of_adjacent_mines(2, 2)).to eq 4
      end
    end
  end

  private

  def random_box(board_size)
    row = rand(1..board_size)
    col = rand(1..board_size)
    [row, col]
  end
end
# rubocop:enable Metrics/BlockLength
