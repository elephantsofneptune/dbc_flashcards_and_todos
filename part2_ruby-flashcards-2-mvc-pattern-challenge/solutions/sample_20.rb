require 'csv'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

#
# game controller class
#
class GameController
  attr_reader :player

  def initialize
    @deck = Deck.new
  end

  def command(command)
    case command
    when "1"
    	"1"
    when "2"
    	"2"
    else
    	exit!
    end
  end

  def get_player
    "\nEnter your name: "
  end

  def new_player(name)
    @player = Player.new(name)
    good_luck!
  end

  def good_luck!
    "Lets see if you know your stuff, #{@player.name}!\n\n"
  end

  def play!
    @deck.cards
  end

  def check_answer(card, answer)
    if answer.downcase == card.answer.downcase
    	@player.add_points(card.points)
    	"Correct!\n"
    else
    	"Incorrect.\n"
    end
  end

  def save_score!
    GameModel.save_score!(player)
  end

  def high_scores
    model = GameModel.new
    top_5 = model.high_scores.sort_by { |player| player.score }.reverse
    high_scores = "\nHigh Scores:\n"
    top_5[0..4].each_with_index do |score, index|
    	high_scores += "#{index + 1}. #{score.name.upcase} - #{score.score}\n"
    end
    high_scores
  end
end


#
# game view class
#
class GameView
  def initialize
    @controller = GameController.new
    start!
  end

  def start!
    title = "\nWelcome to MLB Flash Cards\n"
    welcome = "-" * title.length
    welcome += "\nEnter 1 to play\n"
    welcome += "Enter 2 for high scores\n"
    welcome += "Enter 3 to quit\n"
    welcome += "-" * title.length
    print title + welcome + "\n> "
    command = gets.chomp.strip
    
    choice = @controller.command(command)
    if choice == "1"
    	print @controller.get_player
      get_player_name
    else
    	puts @controller.high_scores
    end

    start!
  end

  def get_player_name
    name = gets.chomp.strip
    puts @controller.new_player(name)
    play!
  end

  def play!
    cards = @controller.play!
    cards.each do |card|
    	ask_question(card)
      get_answer(card)
    end

    print_score
    @controller.save_score!

    start!
  end

  def ask_question(card)
    puts card.question
    print "> "
  end

  def get_answer(card)
    answer = gets.chomp.strip
    puts @controller.check_answer(card, answer)
  end

  def print_score
  	puts "GAME OVER"
    puts @controller.player
  end
end


#
# game model class
#
class GameModel
	attr_reader :cards, :high_scores

	def initialize(file = "mlb.csv")
    @file = file
    @cards = []
    @high_scores = []
    # parse_cards
    parse_high_scores
    noko
	end

  def parse_cards
    CSV.foreach(@file, :headers => true, :header_converters => :symbol) do |row|
      @cards << Card.new(row)
    end
  end

  def parse_high_scores
    CSV.foreach("scoreboard.csv", :headers => true, :header_converters => :symbol) do |row|
      @high_scores << Score.new(row)
    end
  end

  def noko
  	players = []
    page = Nokogiri::HTML(open("http://espn.go.com/mlb/statistics"))   
    page.css("div.bg-elements div#subheader div#content-wrapper div#content.container div.span-6 div#my-players-table.span-4 div.span-2 div.mod-container div.mod-content table.tablehead tr.oddrow td a").each do |player|
    	players << player.text
    end

    parse_leaders(players)
  end

  def parse_leaders(players)
    al_avg = players[1]
    @cards << Card.new({:question => "AL leader in AVG?", :answer => al_avg, :points => 10})
    nl_avg = players[6]
    @cards << Card.new({:question => "NL leader in AVG?", :answer => nl_avg, :points => 10})
    al_hr = players[11]
    @cards << Card.new({:question => "AL leader in HRs?", :answer => al_hr, :points => 10})
    nl_hr = players[16]
    @cards << Card.new({:question => "NL leader in HRs?", :answer => nl_hr, :points => 10})
    al_rbi = players[21]
    @cards << Card.new({:question => "AL leader in RBIs?", :answer => al_rbi, :points => 10})
    nl_rbi = players[26]
    @cards << Card.new({:question => "NL leader in RBIs?", :answer => nl_rbi, :points => 10})
  end

  def self.save_score!(player)
    CSV.open("scoreboard.csv", "ab") do |row|
      row << [player.name, player.points]
    end
  end  
end


#
# deck class
#
class Deck
	attr_reader :cards

  def initialize
    @cards = []
    get_deck
  end

  def get_deck
    model = GameModel.new("mlb.csv")
    @cards = model.cards
  end
end


#
# card class
#
class Card
	attr_reader :question, :answer, :points

  def initialize(args)
    @question = args[:question]
    @answer   = args[:answer]
    @points   = args[:points]
  end
end


#
# player class
#
class Player
	attr_reader :name, :points

  def initialize(name)
    @name = name
    @points = 0
  end

  def add_points(points)
    @points += points.to_i
  end

  def to_s
    "#{@name} - #{@points}"
  end
end

class Score
	attr_reader :name, :score

	def initialize(args)
    @name  = args[:name]
    @score = args[:score]
  end
end


def init
  GameView.new
end

init