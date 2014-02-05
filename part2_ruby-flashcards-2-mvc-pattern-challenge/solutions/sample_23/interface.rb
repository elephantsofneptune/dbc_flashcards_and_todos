require_relative 'models'

module Flashcard

  class Controller
    attr_reader :view, :deck
    def initialize
      @deck = Parser.load_cards_from('flashcard_sample.txt')
      @view = View.new
    end

    def run
      view.display_welcome

      deck.each do |card|
        view.display_definition(card)

        3.times do
          response = gets.chomp

          if card.match?(response)
            break view.display_correct
          else
            view.display_insult
          end
        end

        view.display_answer(card)
      end
    end
  end

  class View
    attr_reader :insults
    def initialize
      @insults = Parser.load_insults_from('insults.txt')
    end

    def display_welcome
      string = <<-EOD
 __     __     __  __                       _       _        _       _
 \\ \\   / /    |  \\\/  |                     ( )     | |      (_)     (_)
  \\ \\\_/ /__   | \\  / | __ _ _ __ ___   __ _|/ ___  | |_ _ __ ___   ___  __ _
   \\   / _ \\  | |\\\/| |/ _` | '_ ` _ \\ / _` | / __| | __| '__| \\ \\ / / |/ _` |
    | | (_) | | |  | | (_| | | | | | | (_| | \\\__ \\ | |_| |  | |\\ V /| | (_| |
    |_|\\\___/  |_|  |_|\\\__,_|_| |_| |_|\\\__,_| |___/  \\\__|_|  |_| \\\_/ |_|\\\__,_|

    EOD
      puts string
    end

    def display_definition(card)
      puts card.definition
    end

    def display_answer(card)
      puts "THE ANSWER WAS: #{card.ans}\n"
      puts '-' * 100
      puts ''
    end

    def display_correct
      puts "\nLucky guess!"
    end

    def display_insult
      puts "\nWRONG ANSWER! #{insults.sample}"
    end
  end
end

program = Flashcard::Controller.new
program.run
