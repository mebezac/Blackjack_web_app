require 'rubygems'
require 'sinatra'

set :sessions, true

require_relative 'helpers.rb'

get '/' do
  if_user('home')
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:player_name] = params[:player_name]
  redirect '/'
end

post '/new_game' do
  redirect '/new_game'
end

get '/new_game' do
  if_user('game/new_game')
end

post '/bet' do
  session[:player_money] = params[:player_money]
  session[:starting_money] = params[:player_money]
  session[:in_play] = false
  redirect '/bet'
end

get '/bet' do
  session[:deck] = deck_builder
  session[:player_hand] = []
  session[:dealer_hand] = []
  session[:player_hand] += deal(session[:deck], 2)
  session[:dealer_hand] += deal(session[:deck], 2)
  session[:bet] = 1
  session[:winner] = ""
  if_user('game/bet')
end

post '/game' do
  session[:bet] = params[:bet]
  session[:show_hit_or_stay] = true
  session[:show_dealer_options] = false
  session[:in_play] = true
  session[:round_over] = false
  session[:win_lose_message] = ''
  session[:deck] = deck_builder
  session[:player_hand] = []
  session[:dealer_hand] = []
  session[:player_hand] += deal(session[:deck], 2)
  session[:dealer_hand] += deal(session[:deck], 2)
  session[:winner] = ""
  redirect '/game'
end

get '/game' do
  if_user('game')
end

post '/game/player/hit' do
  player_hit
end

post '/game/player/stay' do
  session[:show_hit_or_stay] = false
  session[:show_dealer_options] = true
  erb :game
end

post '/game/dealer/hit' do
  dealer_hit
end