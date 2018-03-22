require 'sinatra'
require 'sinatra/reloader' if development?
require_relative "hangman"
include Hangman

get '/' do
    redirect '/start'
end

set :current_dictionary, ""
set :is_new_game, false
set :dictionary, ""
set :secret_word, []
set :fields, " "
set :suitable_letters, []
set :used_letters, []
set :number_of_attempts, 6
set :message, ""

get '/start' do
    @file_names = find_files("dictionary") 

    if !(params['file_name'].nil?) && (settings.dictionary.empty? || settings.current_dictionary != params['file_name'])
        settings.dictionary = load_file("dictionary", params['file_name'])
        game_refresh
        settings.current_dictionary = params['file_name']
    end

    if !(settings.dictionary.empty?) && (settings.is_new_game)
        game_refresh
        settings.is_new_game = false
    end

    if !(params['guess'].nil?) && (settings.number_of_attempts != 0) && (settings.fields != settings.secret_word.join)
        settings.message = "Choose the dictionary first!" if settings.fields == " "
        settings.suitable_letters = settings.secret_word.each_index.select {|index| settings.secret_word[index] == params['guess']}
        push_used_letter(settings.used_letters, params['guess'])
        unless settings.suitable_letters.empty?
            step(settings.suitable_letters, settings.fields, settings.secret_word)
        else
            settings.number_of_attempts -= 1
        end
        gameover_check
    end

    erb :start, :locals => {:file_name => params['file_name'], :dictionary => settings.dictionary, :secret_word => settings.secret_word, :fields => settings.fields, :suitable_letters => settings.suitable_letters, :used_letters => settings.used_letters, :number_of_attempts => settings.number_of_attempts, :message => settings.message}
end

post '/new' do
    settings.message = "Choose the dictionary first!" if settings.fields == " "
    settings.is_new_game = true
    redirect "/start"
end

def game_refresh
    settings.secret_word = choose_word(settings.dictionary)
    settings.fields = "_" * settings.secret_word.size
    settings.used_letters = []
    settings.number_of_attempts = 6
    settings.message = ""
end

def gameover_check
    if settings.number_of_attempts == 0
        settings.message = "Game over! (answer was: '#{settings.secret_word.join}')"
    end

    if settings.fields == settings.secret_word.join
        settings.message = "YOU WIN!"
    end
end
