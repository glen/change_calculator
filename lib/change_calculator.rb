require_relative File.join(App.root, 'lib', 'read_json_file.rb')
require_relative(File.join(App.root, 'helpers', 'formatted_output.rb'))

INPUT_JSON = File.join(App.root, 'data', 'input.json')

class ChangeCalculator
  attr_reader :denominations, :amount, :denominations_to_return, :iteration
  include ReadJsonFile
  include FormattedOutput

  def initialize(amount)
    @denominations = read_input_file(INPUT_JSON)['denominations'].sort.reverse
    @amount = amount.to_i
    @denominations_to_return = Hash.new
    @iteration = 0
  end

  def get_denominations(amount: @amount)
    if amount == 0
      return @denominations_to_return
    end

    @iteration += 1
    print_label(label: "Pass #{@iteration}", color: :blue)
    max_denomination = nil
    0.upto(@denominations.length - 1).each do |i|
      if amount >= @denominations[i]
        max_denomination = @denominations[i]
        break
      end
    end

    number_of_denomination = amount / max_denomination
    balance = amount % max_denomination
    @denominations_to_return[max_denomination.to_s] = number_of_denomination
    print_value(value: "For #{amount} -> #{@denominations_to_return}", color: :yellow)

    get_denominations(amount: balance)
  end

  def self.valid_number?(number)
    number.match?(/^\d+$/)
  end
end
