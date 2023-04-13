# frozen_string_literal: true

require_relative '../lib/game'
require 'rspec'

describe Game do
  describe '#initialize' do
    subject(:start_class) { described_class.new }

    it 'creates new player objects' do
      expect(@name).to be nil
    end
  end

  describe 'set_player_name' do
    subject(:name_setter) { described_class.new }

    it 'changes name from nil to something' do
    end
  end
end
