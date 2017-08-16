This project implements the problem described [here](https://gist.github.com/dan-manges/1e1854d0704cb9132b74). It is implemented in Ruby.

# Setup

Run `bundle install` to install the projects dependencies.
You will also need to have Sqlite installed on your machine 

# Usage

This program will process and aggregate a `.txt` file of commands. To run it enter `ruby main.rb path/to/your/file.txt`. For simplicity you can also use the file `commands.txt`

# Thought Process

## Domain Modeling using `active-record`
While it would have been possible to implement this project using just one or several stand alone methods, I decided to model the data of a driver and trip using `active_record` models backed by an in memory sqlite database. `active_record` an excellent approach for fully modeling entities (domain modeling) by allowing the programmer to succinctly describe each entities' attributes and behavior. Specifically, I created one model to represent a `driver` and a second model to represent a `trip`. Both models encapsulate all attributes and behavior needed to solve the problem statement.

## Scalability ##

While the value of domain modeling might not seem apparent for a relatively simple problem, this approach gives us leeway should we wish to add features in the future. Under this approach, adding new attributes or behavior is a matter of adding a new database column, method or validation. If we need to add a new entity we create a new model. Had our original implementation been doing using stand alone methods we would be faced with the choice of tangling with code that could become increasingly messy, or having to rewrite everything.

## Separation of API from its consumer ##

The models `Driver` and `Trip` describe the attributes and behavior of their real world entities but they do not describe how they should be used. To that end, I created a separate class called `CommandFile` responsible for reading a file of commands, feeding them into the `Driver` and `Trip` models, asking the `driver` model for a report and then printing them to a screen. My decision for separating this functionality into its own class is that entities should only be concerned with describing their data and behavior, not how they should be used. For example, when a command file is given containing invalid, or incomplete trip data, the `Trip` model will produce an invalid instance containing validation errors. By calling `Trip.create!` in `CommandFile#process_trip` an error will be raised alerting the user that their data are invalid. Importantly, this behavior is specific to consumer of the API, not the API itself. We could easily imagine another consumer of this API that would prefer to handle validation errors in a different way (perhaps logging them to a file rather than causing a show stopping error)
