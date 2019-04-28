require 'logger'

class App
  def self.root
    @@root ||= Dir.pwd
  end

  def self.log
    @@logger ||= Logger.new(File.join(@@root, 'log', 'app.log'))
  end
end
