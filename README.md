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

ZdFinder supports searching organizations, tickets and users resources. Any attribute of each particular resource can be used. For example, you can the `_id` to find tickets by its primary key

```
$ bin/zd_finder -r tickets -f _id -v 87db32c5-76a3-4069-954c-7d59c6c21de0

  1 tickets found


Ticket: A Problem in Morocco

ID: 87db32c5-76a3-4069-954c-7d59c6c21de0, external_id: 1c61056c-a5ad-478a-9fd6-38889c3cd728, url: http://initech.zendesk.com/api/v2/tickets/87db32c5-76a3-4069-954c-7d59c6c21de0.json
[...]
```

but you can also use the `external_id` and expect the same results

```
$ bin/zd_finder -r tickets -f external_id -v 1c61056c-a5ad-478a-9fd6-38889c3cd728

  1 tickets found


Ticket: A Problem in Morocco

ID: 87db32c5-76a3-4069-954c-7d59c6c21de0, external_id: 1c61056c-a5ad-478a-9fd6-38889c3cd728, url: http://initech.zendesk.com/api/v2/tickets/87db32c5-76a3-4069-954c-7d59c6c21de0.json
[...]
```

Or search users in a very similar way:

```
$ bin/zd_finder -r users -f _id -v 3

  1 users found


User: Ingrid Wagner

ID: 3, external_id: 85c599c1-ebab-474d-a4e6-32f1c06e8730, url: http://initech.zendesk.com/api/v2/users/3.json
[...]
```

Searching on array fields is also supported, though only one value can be passed at this moment

```
$ bin/zd_finder -r organizations -f tags -v Hendricks

 1 organizations found


  Organization: Xylar

ID: 104, external_id: f6eb60ad-fe37-4a45-9689-b32031399f93, url: http://initech.zendesk.com/api/v2/organizations/104.json
```

Also, you can pass the option `-l` to see all searchable fields by resource

```
 $ bin/zd_finder -l

 AVAIABLE SEARCHABLE FIELDS BY RESOURCE
 ======================================


   Tickets
   -------

   _id assignee_id created_at description due_at external_id has_incidents organization_id priority status subject submitter_id tags type url via

[...]
```

Finally, you can use `-h` or `--help` to see a more detailed help message of all the options available

#### Alternative interface

In the specification document, there was an example of a possible implementation of the application that was using some kind of interactive interface. IMO, interactive interfaces are harder to work with (they cannot be easily scripted and they are harder to debug, since there is not an invocation command that can be shared with developers). This is why I've decided to implement the application using options on the command line. Also, it didn't seem it was a requirement or at least it wasn't specified at such anywhere.

However, I didn't want to submit the exercise without it in case that it was a nice to have and people were expecting it. So, I've created a different branch: [interative-cli]() that changes only the `cli.rb` and the `cli_spec.rb` files.

Please, checkout that branch if you prefer to see the interactive version in action

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
