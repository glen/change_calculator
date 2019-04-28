require File.expand_path('../boot', __FILE__)

["change_calculator.rb"].each do |lib_file|
  require_relative(File.join(App.root, 'lib', lib_file))
end
require_relative(File.join(App.root, 'helpers', 'formatted_output.rb'))

include FormattedOutput

print_value(value: "#{'#'*25} Change Calculator #{'#'*25}", color: :black, background: :white)
begin
  if ChangeCalculator.valid_number?(ARGV[0])
    cc = ChangeCalculator.new(ARGV[0])
    print_label(label: "Denomiations", color: :blue, column_width: 20)
    print_value(value: "[#{cc.denominations.join(', ')}]", color: :yellow)
    print_label(label: "Amount", color: :blue, column_width: 20)
    print_value(value: ARGV[0], color: :yellow)
    cc.get_denominations
    print_label(label: "Change to return", color: :blue)
    print_value(value: cc.denominations_to_return, color: :yellow)
  else
  	puts "Invalid input. Use only numbers."
  	puts
  	exit 1
  end
rescue Exception => e
  raise e
end
puts
