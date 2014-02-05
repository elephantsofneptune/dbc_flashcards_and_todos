require_relative 'controller.rb'
require_relative 'flashcard.rb'

dealer = Controller.new('flash_cards.txt')
dealer.start_game