
require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'lib/cookbook'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

cookbook = Cookbook.new('csv/recipes.csv')

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :add_recipe
end

post '/recipes' do
  cookbook.add_recipe(Recipe.new(params[:r_name], params[:r_desc]))
  redirect '/'
end