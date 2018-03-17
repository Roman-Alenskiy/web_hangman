module Hangman
    require 'yaml'

    # def save_game
    #     puts "\n============================"
    #     puts "Saving game..."
    #     puts "============================"
        
    #     game = {secret_word: @secret_word, fields: @fields, 
    #             used_letters: @used_letters, number_of_attempts: @number_of_attempts}
    #     save_file_name = "../save/#{Time.now.strftime("%d-%m-%Y_%H-%M")}.yaml"
    #     File.write(save_file_name, game.to_yaml)

    #     sleep(1.5)
    #     puts "\n============================"
    #     puts "Game successfuly saved!"
    #     puts "============================"
    # end

    # def load_game
    #     game = load_file("save")
    #     @secret_word = game[:secret_word]
    #     @fields = game[:fields]
    #     @used_letters = game[:used_letters]
    #     @number_of_attempts = game[:number_of_attempts]

    #     puts "\n============================"
    #     puts "Loading game..."
    #     puts "============================"
    #     sleep(1.5)
    #     puts "\n============================"
    #     puts "Game successfuly loaded!"
    #     puts "============================"

    #     show_fields
    #     input_handler
    # end

    def step(suitable_letters, fields, secret_word)
        suitable_letters.each do |index|
            fields[index] = secret_word[index]
        end
    end

    def push_used_letter(used_letters, letter)
        used_letters << letter
        used_letters.uniq!
    end

    def choose_word(dictionary)
        dictionary.downcase!
        dictionary.split("\n").sample.split("").delete_if {|char| char == "\r"}
    end

    def find_files(catalog_name)
        file_names = Dir.glob("public/#{catalog_name}/*")
        file_names.map! do |name|
            name = name[catalog_name.length+8..-1]
        end
        return file_names
    end
        
    def load_file(catalog_name, file_name)
        return YAML.load_file("public/" + catalog_name + file_name) if file_name[-4..-1] == "yaml"
        return File.read("public/" + catalog_name + "/" + file_name)
    end

    def foo
        "bar"
    end

end