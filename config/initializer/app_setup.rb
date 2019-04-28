require 'logger'

class App
  def self.root
    @@root ||= Dir.pwd
  end

  def self.log
    @@logger ||= Logger.new(File.join(@@root, 'log', 'app.log'))
  end

  def self.make_required_directories
    ['data', 'log'].each do |dir|
      Dir.mkdir(File.join(App.root, dir)) unless File.exists?(File.join(App.root, dir))
    end
  end
end

App.make_required_directories
