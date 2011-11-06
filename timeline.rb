require 'sinatra'
require 'erb'
require 'yaml'
require './models/post.rb'

config = YAML.load_file('./config.yml')
config['settings'].each{ |key, value|
    set key, value
}

get '/' do
    @title = settings.title
    @posts = Post.load
    erb :posts
end

get '/ajax' do
    @posts = Post.load(params[:offset].to_i, params[:limit].to_i)
    erb :posts, :layout => false
end

get '/rss' do
    @title = settings.title
    @posts = Post.load
    builder :feed
end
