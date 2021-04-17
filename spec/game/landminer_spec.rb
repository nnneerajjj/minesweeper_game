# frozen_string_literal: true

require_relative '../../minesweeper'

RSpec.describe Landminer do
  let(:board_size) { (3..30).to_a.sample }
  let(:level) { %i[easy medium hard].sample }
  let(:landminer) { Landminer.new(board_size, level) }
  let(:ratios) { { easy: 0.1, medium: 0.2, hard: 0.3 } }

  describe '#initialize' do
    it 'creates a Landminer class instance' do
      expect(landminer).to be_kind_of(Landminer)
    end

    it 'sets the number_of_mines_laid attribute' do
      expect(landminer.number_of_mines_laid).to eq(0)
    end
  end

  describe '#lay_mines' do
    before do
      @board = landminer.lay_mines
    end

    it 'returns a board' do
      expect(@board).to be_kind_of(Board)
    end

    it 'lays correct number of mines' do
      expect(landminer.number_of_mines_laid).to eq((ratios[level] * (board_size**2)).ceil)
    end
  end
end
