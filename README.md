# Decidim::Feedback

[![Build Status](https://travis-ci.com/mainio/decidim-module-feedback.svg?branch=master)](https://travis-ci.com/mainio/decidim-module-feedback)
[![codecov](https://codecov.io/gh/mainio/decidim-module-feedback/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-feedback)

The gem has been developed by [Mainio Tech](https://www.mainiotech.fi/).

A [Decidim](https://github.com/decidim/decidim) module that provides the
possibility to attach feedback modals to any section of the site and attach the
feedbacks to specific objects on the site.

This is a technical module that adds this ability to Decidim but the feedback
functionality needs to be manually added and configured to the individual views
in order to use it.

Development of this gem has been sponsored by the
[City of Helsinki](https://www.hel.fi/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-feedback"
```

And then execute:

```bash
$ bundle
$ bundle exec rails decidim_feedback:install:migrations
```

## Usage

First you need to add the following to the helper which is loaded to the view
where you want to trigger the modal:

```ruby
module ApplicationHelper
  include Decidim::Feedback::FeedbackHelpe
end
```

If you want to properly display the stars selector, add this to your
`application.scss`:

```scss
@import "decidim/feedback/feedback-form";
```

In order to trigger the feedback modals on actions, e.g. when something is
stored, add the following to the view in that state:

```erb
<%= trigger_feedback_modal(resource, metadata: { context: "your_resource", action: "publish" }) %>
```

Give the resource model for which this feedback was left for. That resource
should be locatable with the Decidim's resource locator. You can also trigger
the feedback modal without a resource by giving `nil` instead of the resource
to the modal trigger method.

In the `metadata` you can specify anything you'd like to further target what
this feedback is about. This information will be stored with the feedback and
displayed in the feedback notification. This can be also used to define who
receives this feedback.

### Where can I see the feedback?

Go to the admin panel and you'll find a new section there named "Feedback". You
can see all the feedback here.

### Can I send the feedback to specified email addresses?

You sure can. Under the "Feedback" section in the admin panel, you'll see a
sub-section link named "Recipient groups". Go to that view to define who will
receive the feedback notification emails.

Here you can define feedback recipient groups and the emails who the feedback
will be sent to. Create a new recipient group with a name of your choise and
define the recipient emails there. The feedback will be sent to these emails.
The recipient group's name should be understandable by all admin users, so use a
name that specifies either who the recipients are or what kind of feedback is
sent to these recipients. A good name to start with is "All feedback" based on
these suggestions.

In the "Restrictions" section you can define restrictions for the feedback that
will be sent to these recipients. The restrictions will be matched against the
feedback metadata that you defined when you triggered the feedback modal. If you
want the group to receive all feedback, leave these undefined.

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Developing

To start contributing to this project, first:

- Install the basic dependencies (such as Ruby and PostgreSQL)
- Clone this repository

Decidim's main repository also provides a Docker configuration file if you
prefer to use Docker instead of installing the dependencies locally on your
machine.

You can create the development app by running the following commands after
cloning this project:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake development_app
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

Then to test how the module works in Decidim, start the development server:

```bash
$ cd development_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rails s
```

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add the environment variables to the root directory of the project in a file
named `.rbenv-vars`. If these are defined for the environment, you can omit
defining these in the commands shown above.

#### Code Styling

Please follow the code styling defined by the different linters that ensure we
are all talking with the same language collaborating on the same project. This
project is set to follow the same rules that Decidim itself follows.

[Rubocop](https://rubocop.readthedocs.io/) linter is used for the Ruby language.

You can run the code styling checks by running the following commands from the
console:

```
$ bundle exec rubocop
```

To ease up following the style guide, you should install the plugin to your
favorite editor, such as:

- Atom - [linter-rubocop](https://atom.io/packages/linter-rubocop)
- Sublime Text - [Sublime RuboCop](https://github.com/pderichs/sublime_rubocop)
- Visual Studio Code - [Rubocop for Visual Studio Code](https://github.com/misogi/vscode-ruby-rubocop)

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

### Localization

If you would like to see this module in your own language, you can help with its
translation at Crowdin:

https://crowdin.com/project/decidim-access-requests

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
