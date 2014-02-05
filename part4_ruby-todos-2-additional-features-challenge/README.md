# Ruby Todos 2 Additional Features 
 
##Learning Competencies 

* Use a MVC design pattern to model a problem
* Create well-defined classes with a single responsibility
* Identify and implement classes based on real world requirements
* Implement clean and flexible interfaces between objects

##Summary 

 We're going to add three new commands to our TODO app.

```text
$ ruby todo.rb list:outstanding
$ ruby todo.rb list:completed
$ ruby todo.rb tag <task_id> <tag_name_1> <tag_name_2> ... <tag_name_N>
$ ruby todo.rb filter:<tag_name>
```

In English, these correspond to the following user stories:

1. As a user, I want to list all my outstanding tasks sorted by *creation* date.
2. As a user, I want to list all my completed tasks sorted by *completion* date.
3. As a user, I want to tag tasks, e.g., home, work, errand, etc.
4. As a user, I want to list all tasks with a particular tag sorted by *creation* date.

Each one of these features will likely require changing the file format and the parsing code that you've written.

##Releases

###Release 0 : Add Features

####Implement the list:outstanding command

Implement a command that works like

```text
$ ruby todo.rb list:outstanding
```

This should display a list of outstanding tasks sorted by *completion date*.

*User Experience Alert*: They say that defaults matter.  What do you think the default sort direction should be and why?  Newest tasks first or oldest tasks first?  Would your answer change if a user had a really long TODO list?

#### Implement the list:completed command

Implement a command that works like

```text
$ ruby todo.rb list:completed
```

This should display a list of outstanding tasks sorted by *completion date*.  The same **user experience** considerations apply here, too.

#### Implement the tag command

Implement a command that works like

```text
$ ruby todo.rb list
1. Eat some pie
2. Walk the dog

$ ruby todo.rb tag 2 personal pet-care
Tagging task "Walk the dog" with tags: personal, pet-care
```

Each task can have multiple tags, so you'll have to change your file format to accommodate that.  

If you implemented the extra credit feature from part 1 about the `todo.txt` file being human-readable, try to keep that constraint: you should be able to print out `todo.txt`, hand it to your grandmother, and have her recognize it as a TODO list.

###Release 1 : Implement the filter command

Implement a `filter` command that works like

```text
$ ruby todo.rb list
1. Eat some pie
2. Walk the dog

$ ruby todo.rb tag 2 personal pet-care
Tagging task "Walk the dog" with tags: personal, pet-care

$ ruby todo.rb filter:personal
2. Walk the dog [personal]
```

This should display a list of all tasks with the *personal* tag sorted by *creation date*.

## Resources

**SPOILER ALERT: These contain solutions to the Todo challenge - make sure you have solved it on your own first!**

* [Code for Tanner's ToDo app](https://gist.github.com/openspectrum/02239bf831cb7ad4b31f) 
* [Jesse's talk on refactoring the ToDo app](http://shereef.wistia.com/medias/c9cbc4fc79)  