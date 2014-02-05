# Solution for Challenge: Ruby Flashcards 2: MVC Pattern & More. Started 2013-06-15T00:24:48+00:00

https://github.com/hussain283/spawncamping-dubstep.git

https://github.com/hussain283/spawncamping-dubstep

def load(filename)
    file = File.open(filename,"r")
    
    data = file.read # usable data
    file.close

    data = data.split("\n")
    data.delete(" ")

    @cards = data.each_slice(2).map {|pair| FlashCard.new(definition: pair[0], answer: pair[1]) }
  end