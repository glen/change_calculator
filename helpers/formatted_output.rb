module FormattedOutput
  def print_value(value: 'Value', color: 'white', column_width: 20, background: nil)
    puts "#{value}".ljust(column_width).colorize(color: color, background: background)
  end

  def print_label(label: 'Label', color: :white, column_width: 20, background: nil)
    print "#{label}:".ljust(column_width).colorize(color: color, background: background)
  end
end