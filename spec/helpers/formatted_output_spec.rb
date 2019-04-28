require 'spec_helper'
require_relative File.join(App.root, 'helpers', 'formatted_output.rb')

class TestClass
  include FormattedOutput
end

describe 'ReadJsonFile' do
  before(:all) do
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  after(:all) do
    $stdout = @original_stdout
  end

  let(:test_object) { TestClass.new }

  describe 'print_label' do
    it 'formats the label with a colon' do
      test_object.print_label(label: "Name", color: :blue, column_width: 15)
      expect($stdout.string).to match(/Name:/)
    end

    it 'formats the value with a newline at the end' do
      test_object.print_value(value: "Acme", color: :blue, column_width: 15)
      expect($stdout.string).to match(/Acme.*\n/)
    end
  end
end
