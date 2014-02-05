require_relative 'parser.rb'
require_relative 'ui.rb'
require_relative 'card.rb'
require_relative 'deck.rb'
require_relative 'controller.rb'



def main(filename)
  Controller.new(filename)
end

if ARGV
  main(ARGV[0])
else
  main('terms.txt')
end
