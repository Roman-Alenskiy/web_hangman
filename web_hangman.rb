require 'sinatra'
require 'sinatra/reloader' if development?
require_relative "hangman"
include Hangman

get '/' do
    redirect '/start'
end

current_dictionary = ""
is_new_game = false
@@dictionary = ""
@@secret_word = []
@@fields = " "
@@suitable_letters = []
@@used_letters = []
@@number_of_attempts = 6
@@message = ""

get '/start' do
    @file_names = find_files("dictionary") 

    if !(params['file_name'].nil?) && (@@dictionary.empty? || current_dictionary != params['file_name'])
        @@dictionary = load_file("dictionary", params['file_name'])
        game_refresh
        current_dictionary = params['file_name']
    end

    if !(@@dictionary.empty?) && (is_new_game)
        game_refresh
        is_new_game = false
    end

    if !(params['guess'].nil?) && (@@number_of_attempts != 0) && (@@fields != @@secret_word.join)
        @@message = "Choose the dictionary first!" if @@fields == " "
        @@suitable_letters = @@secret_word.each_index.select {|index| @@secret_word[index] == params['guess']}
        push_used_letter(@@used_letters, params['guess'])
        unless @@suitable_letters.empty?
            step(@@suitable_letters, @@fields, @@secret_word)
        else
            @@number_of_attempts -= 1
        end
        gameover_check
    end

    erb :start, :locals => {:file_name => params['file_name']}
end

post '/new' do
    @@message = "Choose the dictionary first!" if @@fields == " "
    is_new_game = true
    redirect "/start"
end

def game_refresh
    @@secret_word = choose_word(@@dictionary)
    @@fields = "_" * @@secret_word.size
    @@used_letters = []
    @@number_of_attempts = 6
    @@message = ""
end

def gameover_check
    if @@number_of_attempts == 0
        @@message = "Game over! (answer was: '#{@@secret_word.join}')"
    end

    if @@fields == @@secret_word.join
        @@message = "YOU WIN!"
    end
end
