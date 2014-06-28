require 'sinatra'
require 'coffee-script'
require_relative 'woodpecker/page'

get '/load' do
  url = URI::decode(params[:url])
  doc = WoodPecker::Page.new url
  doc.preprocess
  doc.html
end

get '/assets/woodpecker.js', :provides => [:js] do
  CoffeeScript.compile File.read("javascripts/woodpecker.coffee")
end

get '/assets/tinyquery.js', :provides => [:js] do
  File.read("javascripts/tinyquery.js")
end
get '/assets/xpath.js', :provides => [:js] do
  File.read("javascripts/xpath.js")
end