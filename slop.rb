require 'sinatra'
require 'erb'
require 'yaml'
require './models/post'

config = YAML.load_file('./config.yml')
config['settings'].each{ |key, value|
    set key, value
}

get '/' do
    @posts = Post.get 0, 50
    @title = settings.title
    erb :index
end
