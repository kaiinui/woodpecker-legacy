Bundler.require

require 'sinatra'
require 'coffee-script'
require 'sinatra/asset_pipeline'
require_relative 'woodpecker/page'

register Sinatra::AssetPipeline

get '/load' do
  url = URI::decode(params[:url])
  doc = WoodPecker::Page.new url
  doc.preprocess
  doc.html
end