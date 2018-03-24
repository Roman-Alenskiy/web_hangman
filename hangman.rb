module Hangman

    def step(session)
        session['suitable_letters'].each do |index|
            session['fields'][index] = session['secret_word'][index]
        end
    end

    def push_used_letter(session, letter)
        session['used_letters'] << letter
        session['used_letters'].uniq!
    end

    def choose_word(current_dictionary)
        dictionary = load_file('dictionary', current_dictionary)
        word = dictionary.split("\n").sample
        word.downcase!
        word = word.split("").delete_if {|char| char == "\r"}
        return word
    end

    def find_files(catalog_name)
        file_names = Dir.glob("public/#{catalog_name}/*")
        file_names.map! do |name|
            name = name[catalog_name.length+8..-1]
        end
        return file_names
    end
        
    def load_file(catalog_name, file_name)
        return File.read("public/" + catalog_name + "/" + file_name)
    end

    def game_refresh(session)
        session['secret_word'] = choose_word(session['current_dictionary'])
        session['fields'] = "_" * session['secret_word'].size
        session['used_letters'] = []
        session['number_of_attempts'] = 6
        session['message'] = ""
    end
    
    def gameover_check(session)
        if session['number_of_attempts'] == 0
            session['message'] = "Game over! (answer was: '#{session['secret_word'].join}')"
        end
    
        if session['fields'] == session['secret_word'].join
            session['message'] = "YOU WIN!"
        end
    end
    
    def initial_assignment(session)
        if session['secret_word'].nil?
            session['current_dictionary'] = ""
            session['is_new_game'] = false
            session['secret_word'] = []
            session['fields'] = " "
            session['suitable_letters'] = []
            session['used_letters'] = []
            session['number_of_attempts'] = 6
            session['message'] = ""
        end
    end

    def foo
        "bar"
    end

end