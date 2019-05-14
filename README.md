# ZdFinder

CLI interface to find Zendesk tickets, users or organizations easily

## Installation

The application is written in ruby, using the latest ruby version available at this time (2.6.3), though it should work with any version above 2.5.X.

If you don't have ruby installed in your system, the easier way to install it is using [rbenv](https://github.com/rbenv/rbenv). You can have a look at its [README](https://github.com/rbenv/rbenv#installation) to find out how it can installed in your system.

You will also need to install the [bundler](https://bundler.io/) gem (though if you have installed ruby using rbenv it's installed by default)

Once you have ruby and bundler install, clone this repo and install all its dependencies using:

```
$ bundle install
```

You are all set! :tada:

## Running the application

Execute the launcher file provided under the `bin` folder and follow the options. The application can be exited at any time by typing `quit` and it also controls that the resource and field values are correct. The application has the same functionalities as it does on original version on the master branch

```
$ bin/zd_finder
```

## Tests

The application should be covered at 100% by integration tests, though some unit tests have been also added to ensure all the different resource fields are rendered on the output, along with the relations between the resources.

IMO, the integration test should always be favored given that they offer a better guarantee that everything is working as expected, plus they are not tied to the implementation in any way. This makes easier to refactor the internals without breaking any tests.

Also, I like to write the integration tests in a way that describes the expected behavior of the program, and this is something I really like from RSpec. The provided test examples are covering all the expected scenarios such as:
 - Showing the help.
 - Showing the list of fields that can be used for filtering.
 - Ensure we require a valid resource and field.
 - Ensure an empty value can be passed and it matches the entries with a blank value on that field.
 - Multiple resources can be found.
 - etc.

If you want to run the test, you can use the rake helper or directly the rspec command.

```
$ rake spec # or rspec
```

Also, I've decided to add `rubocop` to ensure the code styling was consistent and easier to read. Same as `rspec`, it can be run using the `rake` helper or directly by calling `rubocop`

```
$ rake rubocop # or rubocop
```

Moreover, the default `rake` tasks runs both programs automatically, so you can just use that one

```
$ rake
```
