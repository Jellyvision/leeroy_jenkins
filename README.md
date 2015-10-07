# leeroy_jenkins

## Description
A CLI tool for managing Jenkins job configurations: bulk update, backup, and restore your Jenkins job configurations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'leeroy_jenkins'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install leeroy_jenkins

## Usage

Set your `LEEROY_JENKINS_USERNAME`, `LEEROY_JENKINS_PASSWORD`, and `LEEROY_JENKINS_SERVER_URL` appropriately for your Jenkins. These can also be overridden with command line options.

    $ leeroy --help
	$ leeroy help [COMMAND_NAME]

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the unit tests. You can also run `bundle exec bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec exe/leeroy` to use the gem in this directory, ignoring other installed copies of this gem.

To run the acceptance tests, run `vagrant up` to start your own Jenkins instance. This may take 5-10 minutes, but when finished you'll be able to access Jenkins at `192.168.50.33:8080` in your web browser. Then run `bundle exec cucumber`.

