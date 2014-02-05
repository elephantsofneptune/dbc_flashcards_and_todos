# Ruby Flashcards 2 MVC Pattern 
 
##Learning Competencies 

* Use the model-view-controller pattern to organize code and decouple concerns
* Create interactive command-line applications with data persistence
* Implement a 'user session' for console input and store session data when necessary
* Explain the difference between refactoring and adding (or removing) domain logic

##Summary 

 By this point, you have managed to build a flashcards app.  Good job.  Although, you have to admit, it is still very basic.  And we did not even explicitly discuss using any design patterns last time, which could improve the structure of your code.  Let's make some changes to improve the code quality and add a few handy new features.

There is no boilerplate code for this challenge – you should build upon the code you've already written for the prerequisite challenge.

Primary changes:

- Implement the Model-View-Controller design pattern
- Add support for multiple decks of cards
- Keep track of user's guess attempts and repeat failed cards

##Releases

###Release 0 : Implement MVC

First, read the Wikipedia page on [Model-View-Controller](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).  Answer these questions for yourself:

- What does a model represent?
- What is the responsibility of a controller?
- How is the view used?

Look at the high-level picture of your flashcard app.  If you put some thought into separation of concerns, you may notice that your code already follows somewhat of an MVC pattern.  If not, how does your code differ from this design pattern?

As best as you can, **refactor your code so that it follows the MVC design pattern**.  Remember, refactoring means that you *do not change the behavior of your program*, just the way that it is written.

Your implementation will differ from that of your peers.  Don't worry about the differences too much at this point.  The important thing to consider is how well you can represent the abstract concept of a design pattern through well-structured code.

As an example, here is one way that you could implement MVC in the hospital app:

`hospital.rb`

```ruby
class Hospital
  attr_reader :patients, :employees

  def find_patient_by_name(name)
    patients.select { |patient| patient.name == name }
  end

  # and so on…
end
```

`hospital_controller.rb`

```ruby
class HospitalController
  def initialize(hospital, view)
    @hospital = hospital
    @view     = view
  end

  def run
    @view.welcome
    @view.prompt
    respond_to(user_input)
  end

  def user_input
    gets.chomp
  end

  def respond_to(input)
    command  = input[0]
    argument = input[1]

    case command
    when "all_patients"
      @view.show(@hospital.patients)
    when "find_patient"
      @view.show(@hospital.find_patient_by_name(argument))
    end
  end
end
```

`hospital_view.rb`

```ruby
class HospitalView
  def welcome
    puts "Welcome to the hospital"
  end

  def prompt
    puts "What would you like to do?"
  end

  def show(obj)
    puts obj
  end
end
```

Analyze the above code and see if you can figure out how these files interact with each other.

###Release 1 : Support multiple decks

Chances are you've hard-coded the source file for your cards into your program.  Maybe you have code like this:

```ruby
Flashcards::Deck.from_file('sample_cards.txt')
```

…or like this…

```ruby
module Flashcards
  SOURCE_FILE = 'sample_cards.txt'
  
  # more stuff…
end
```

…but I'm guessing that you have not written your program to allow the user to define their own source file for the deck of cards.  Here's how the interface might look for that:

```text
$ ruby flashcards.rb my_cards.txt
Welcome to Ruby Flash Cards.  You're using the deck 'my_cards'

To play, just enter the correct term for each definition.  Ready?  Go!

[ and so on… ]
```

**Change your code to allow any source file to be used.**

Some questions to ponder, as this feature may introduce new complexities:

- Do you supply any defaults?
- How does your program react to improperly formatted source files?  Does it provide useful, actionable feedback?

###Release 2 : Enhance.  Enhance.  Enhance your logic.

Let's revisit the domain logic of your program.  The term *domain logic* refers to the rules that govern the behavior of your application.  For example, the way that your application responds to an incorrect guess from the user is a part of its domain logic.

So far, the domain logic is not that advanced.  Maybe you've already implemented some features like allowing the user multiple guesses or providing hints to the user.  In order to make this flashcard game more robust and useful, let's build out some more features.

Instead of providing you with an interface example for these features, you will instead implement them through user stories.  A user story is just another way to model domain logic, just like pseudocode or a state diagram.

Here are the user stories you need to solve for:

- **As a user, I want the application to keep track of how many attempts I take to guess each term on the card.**
- **As a user, I want to be able to repeat the cards which I struggled with the most.**

As you begin to plan out how to solve these problems, you should be thinking about where the attempt data will be stored, and which part of your application should be responsible for managing that data.  

At this point, it is not necessary to persist the number of attempts.  In other words, you only need to keep track of the number of attempts for a given **session**.  When the program finishes executing, any data about the number of attempts will vanish.  Bye, bye.

#### OPTIONAL: Make it extra-fancy

How else can you improve this program?  Design and build any other awesome features you want.

Here are a few prompts to get your wheels turning:

- What would it take to persist user attempts so that you have a running tally of all attempts for every card?
- Can you create cards with multiple-choice answers?
- Could your app give partial "credit" to nearly correct answers?  I.e. what if the user guesses correctly, but misspells it or is off by one letter? 


##Optimize Your Learning 

Post-challenge questions

- Was it difficult to adopt your code to the MVC design pattern?  Why or why not?
- What parts of your code did you have to change to allow for a variable source file?  
- Which part of your application handles the source file parsing?  Why is this the right place for the code to live?
- How did you connect user guess attempts with their associated cards?  Should the cards "know" about the number of attempts?
