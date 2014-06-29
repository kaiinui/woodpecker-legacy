Bundler.require

require 'sinatra'
require 'sinatra/asset_pipeline'
require_relative 'woodpecker/page'

register Sinatra::AssetPipeline

get '/load' do
  url = URI::decode(params[:url])
  doc = WoodPecker::Page.new url
  doc.preprocess
  doc.html
end

post '/schemas' do
  # [TODO]: :domain or :pattern, how to set pattern?
  # [TODO]: save it in DynamoDB or SQS it.
  params[:schema].to_s
end