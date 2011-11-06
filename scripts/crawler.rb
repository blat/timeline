require 'yaml'
require './models/crawler.rb'

crawler = Crawler.new

config = YAML.load_file('./config.yml')
config['services'].each do |name,options|
    name = options['type']
    require "./models/#{name}.rb"
    service = Object.const_get(name.capitalize).new options
    crawler.add_service service
end

crawler.run
