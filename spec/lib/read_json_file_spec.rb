require 'spec_helper'
require_relative File.join(App.root, 'lib', 'read_json_file.rb')

class TestClass
  include ReadJsonFile
end

describe 'ReadJsonFile' do
  let(:test_object) { TestClass.new }

  describe 'generate_sample_input_file' do
    let(:filename) { File.join('/tmp', "input_#{rand(1000)}.json") }
    let(:sample_input) { JSON.pretty_generate({"denominations"=>[]}) }

    it 'generates a sample input json file' do
      file = double('file')
      expect(File).to receive(:open).with(filename, 'w').and_yield(file)
      expect(file).to receive(:puts).with(sample_input)
      test_object.generate_sample_input_file(filename)
    end
  end

  describe 'validate_entries_in_json' do
    it 'returns false if all input keys have values' do
      expect(test_object.input_file_not_filled?({'denominations' => [3, 4, 5]})).to be false
      expect(test_object.input_file_not_filled?({'denominations' => [3, 4, 5], 'another_input' => 'something'})).to be false
    end

    it 'returns true if any inout keys are not filled' do
      expect(test_object.input_file_not_filled?({'denominations' => []})).to be true
      expect(test_object.input_file_not_filled?({'denominations' => [3, 4, 5], 'another_input' => ''})).to be true
    end
  end

  describe 'read_input_file' do
    context 'file is present' do
      let(:filename) { File.join('/tmp', "valid_file_persent.json") }
      let(:valid_input_file_contents) { {'denominations' => [1, 2, 3, 4]} }
      let(:invalid_input_file_contents) { {'denominations' => []} }

      before do
        allow(File).to receive(:exists?).with(filename).and_return(true)
      end

      it 'obtains the json for input' do
        allow(File).to receive(:read).with(filename).and_return(valid_input_file_contents.to_json)
        expect( test_object.read_input_file(filename) ).to eq( valid_input_file_contents )
      end

      context 'with values not filled in' do
        before do
          allow(File).to receive(:read).with(filename).and_return(invalid_input_file_contents.to_json)
        end

        it 'logs a warning' do
          expect(App.log).to receive(:warn).with("Fill in the appropriate values for the input.json file")
          expect { test_object.read_input_file(filename) }.to raise_error(RuntimeError)
        end

        it 'logs an error' do
          expect(App.log).to receive(:error).with(/Exception with input.json file/)
          expect { test_object.read_input_file(filename) }.to raise_error(RuntimeError)
        end
      end
    end

    context 'file not present' do
      let(:filename) { File.join('/tmp', "not_valid_path.json") }

      before do
        allow(test_object).to receive(:generate_sample_input_file).with(filename)
        allow(File).to receive(:exists?).with(filename).and_return(false)
      end

      it 'generates a sample input file' do
        expect(test_object).to receive(:generate_sample_input_file).with(filename)
        expect { test_object.read_input_file(filename) }.to raise_error(RuntimeError)
      end

      it 'logs a warning' do
        expect(App.log).to receive(:warn).with("Created file #{filename} and set the appropriate values!")
        expect { test_object.read_input_file(filename) }.to raise_error(RuntimeError)
      end

      it 'logs an error' do
        expect(App.log).to receive(:error).with(/Exception with input.json file./)
        expect { test_object.read_input_file(filename) }.to raise_error(RuntimeError)
      end
    end
  end
end
