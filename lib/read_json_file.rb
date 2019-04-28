require 'json'

module ReadJsonFile
  def generate_sample_input_file(path_to_file)
    sample_file = {"denominations"=>[]}
    File.open(path_to_file, 'w') do |file|
      file.puts JSON.pretty_generate(sample_file)
    end
  end

  def input_file_not_filled?(json)
    json.values.any?(&:empty?)
  end

  def read_input_file(path_to_file)
    begin
      input = {}
      if File.exists?(path_to_file)
        input = JSON.load(File.read(path_to_file))
        if input_file_not_filled?(input)
          App.log.warn 'Fill in the appropriate values for the input.json file'
          raise 'File input.json incomplete!'
        end
        input
      else
        generate_sample_input_file(path_to_file)
        App.log.warn "Created file #{path_to_file} and set the appropriate values!"
        raise 'No file input.json present. Created, now fill it in.'
      end
    rescue => e
      App.log.error "Exception with input.json file #{e.inspect}"
      raise e
    end
  end
end
