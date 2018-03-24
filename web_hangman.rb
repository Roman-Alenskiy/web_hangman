require 'sinatra'
require 'sinatra/reloader' if development?
require_relative "hangman"
include Hangman

get '/' do
    redirect '/start'
end

enable :sessions

get '/start' do
    initial_assignment(session)
    @file_names = find_files("dictionary") 

    if !(params['file_name'].nil?) && (session['current_dictionary'] != params['file_name'])
        session['current_dictionary'] = params['file_name']
        game_refresh(session)
    end

    if !(session['current_dictionary'].empty?) && (session['is_new_game'])
        game_refresh(session)
        session['is_new_game'] = false
    end

    if !(params['guess'].nil?) && (session['number_of_attempts'] != 0) && (session['fields'] != session['secret_word'].join)
        session['suitable_letters'] = session['secret_word'].each_index.select {|index| session['secret_word'][index] == params['guess']}
        if !(session['suitable_letters'].empty?)
            step(session)
            push_used_letter(session, params['guess'])
        elsif session['current_dictionary'].empty?
            session['message'] = "Choose the dictionary first!"
        else
            session['number_of_attempts'] -= 1
            push_used_letter(session, params['guess'])
        end
        gameover_check(session)
    end

    erb :start, :locals => {:current_dictionary => session['current_dictionary'], :dictionary => session['dictionary'], :secret_word => session['secret_word'], :fields => session['fields'], :suitable_letters => session['suitable_letters'], :used_letters => session['used_letters'], :number_of_attempts => session['number_of_attempts'], :message => session['message']}
end

post '/new' do
    session['message'] = "Choose the dictionary first!" if session['fields'] == " "
    session['is_new_game'] = true
    redirect "/start"
end
