# Root coding problem statement
## by Jacob Stoebel

This project implements the problem described [here](https://gist.github.com/dan-manges/1e1854d0704cb9132b74). It is implemented in Ruby.

# Setup

Run `bundle install` to install the project's dependencies.
You will also need to have Sqlite installed on your machine 

# Usage

This program will process and aggregate a `.txt` file of commands. To run it enter `ruby main.rb path/to/your/file.txt`. For simplicity you can also use the file `commands.txt`

To run the test suite run `rspec`

# Thought Process

## Domain Modeling using `active-record`
While it would have been possible to implement this project using just one or several standalone methods, I decided to model the data of a driver and trip using `active_record` models backed by an in-memory sqlite database. `active_record` is an excellent approach for fully modeling entities (domain modeling) by allowing the programmer to succinctly describe each entity's attributes and behavior. Specifically, I created one model to represent a driver and a second model to represent a trip. Both models encapsulate all attributes and behavior needed to represent their real world counterparts in order to solve the problem.

## Scalability ##

While the value of domain modeling with `active_record` might not seem apparent for a relatively simple problem, this approach gives us leeway should we wish to add features in the future. Under this approach, adding new attributes or behavior is a simple matter of adding a new database column, method or validation. If we need to add a new entity we create a new model and wire up the appropriate relationships. If we would like to move this behavior to the web, we can migrate the models to a Rails project. Had our original implementation been done using stand alone methods we would be faced with the choice of tangling with code that could become increasingly messy, or having to rewrite everything.

## Separation of API from its consumer ##

The models `Driver` and `Trip` need to describe the attributes and behavior of their real world entities but they do not need to describe _how_ they should be used. To that end, I created a separate class called `CommandFile` responsible for reading a file of commands, feeding them into the `Driver` and `Trip` models, asking the `Driver` model for a report and then printing them to a screen. The models do not need to know or care how data will be fed into them. For example, the `Trip` model describes a `start_time` and `end_time` as `DateTime` objects. The command file input by the user describes start and end times as strings. Since a DateTime object is the best way for a computer to reason about time, the `CommandFile` class is responsible for converting the time as a string into the format required by the `Trip` model. We do not want to presume to know how all future consumers of the `Trip` model will be handling data. Instead, we present a clear contract: to create a record, give the `Trip` model a valid DateTime for `start_time` and `end_time`.

The models are also not concerned with the end behavior when things go wrong. 
For example, when a command file contains invalid, or incomplete trip data, the `Trip` model will produce an invalid instance containing validation errors. By calling `Trip.create!` in `CommandFile#process_trip` an error will be raised alerting the user that their data are invalid. Importantly, this behavior is specific to the consumer of the API, not the API itself. We could easily imagine another consumer of this API that would need to handle validation errors in a different way (perhaps logging them to a file rather than causing a show stopping error)

# Testing

I created unit tests for both the `Trip` and `Driver` model as well as integration tests for the interaction of the `CommandFile` class with the `Trip` and `Driver` models. Specifically I was sure to test for the following

## unit tests for models
 - all validations trigger the expected errors when presented with invalid data
 - all pathways of all methods produce the expected output

## integration tests for `CommandFile` and Models

 -  correct exceptions are raised for invalid commands
 -  correct exceptions are raised for data that lead to invalid records
 -  a valid data file correctly processes the data and outputs the expected result.

