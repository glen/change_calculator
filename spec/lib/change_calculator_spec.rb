require 'spec_helper'
require_relative File.join(App.root, 'lib', 'change_calculator.rb')

describe 'ChangeCalculator' do
  let(:denominations) { [5, 20, 10, 2, 1] }
  let(:json_data) { {'denominations' => denominations} }

  describe 'initialize' do
    before do
      allow_any_instance_of(ChangeCalculator).to receive(:read_input_file).and_return(json_data)
    end

    it 'sets the instance variable - input' do
      cc = ChangeCalculator.new('5')
      expect(cc.denominations).to eq(denominations.sort.reverse)
    end

    it 'sets the instance variable - no_to_search' do
      cc = ChangeCalculator.new('5')
      expect(cc.amount).to eq(5)
    end

    it 'sets the instance variable - no_to_search' do
      cc = ChangeCalculator.new('5')
      expect(cc.denominations_to_return).to be_empty
    end
  end

  describe 'denominations_to_return' do

    before do
      allow_any_instance_of(ChangeCalculator).to receive(:read_input_file).and_return(json_data)
      allow_any_instance_of(ChangeCalculator).to receive(:print_label)
      allow_any_instance_of(ChangeCalculator).to receive(:print_value)
    end

    context 'number present' do
      it 'returns the location of the number to search if present' do
        cc = ChangeCalculator.new('63')
        expect(cc.get_denominations).to eq({'20' => 3, '2' => 1, '1' => 1})
      end
    end

    context 'number not present' do
      it 'returns -1 if the number to search is not present' do
        cc = ChangeCalculator.new('28')
        allow(cc).to receive(:read_input_file).and_return( json_data )
        expect(cc.get_denominations).to eq({'20' => 1, '5' => 1, '2' => 1, '1' => 1})
      end
    end

    it 'sets the iterations' do
      cc = ChangeCalculator.new('40')
      allow(cc).to receive(:read_input_file).and_return( json_data )
      cc.get_denominations
      expect(cc.iteration).to eq(1)
    end
  end

  describe 'valid_number?' do
    ['0', '1', '5', '10', '345', '36126'].each do |number_as_string|
      it "returns true if input is a whole positive number - #{number_as_string}" do
        expect(ChangeCalculator.valid_number?(number_as_string)).to be true
      end
    end

    ['-5', '1.3', 'a_string', '1ten'].each do |number_as_string|
      it "returns false if input is a whole positive number - #{number_as_string}" do
        expect(ChangeCalculator.valid_number?(number_as_string)).to be false
      end
    end
  end
end