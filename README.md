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

Set your `LEEROY_JENKINS_USERNAME`, `LEEROY_JENKINS_PASSWORD`, and `LEEROY_JENKINS_SERVER_URL` environment variables appropriately for your Jenkins. These can also be overridden with command line options. Run `leeroy --help` to see the available sub-commands and options:

    $ leeroy --help
    Commands:
      leeroy append NEW_NODE.xml      # Append to XML nodes in jenkins jobs' config.xml
      leeroy backup BACKUP_DIR_PATH   # Save the config.xml of Jenkins jobs to disk, BACKUP_DIR created if it does not exist
      leeroy delete                   # Delete XML nodes in jenkins jobs' config.xml
      leeroy help [COMMAND]           # Describe available commands or one specific command
      leeroy replace NEW_NODE.xml     # Replace XML nodes in jenkins jobs' config.xml
      leeroy restore BACKUP_DIR_PATH  # Restore config.xml files to Jenkins jobs from backups

    Options:
      [--dry-run], [--no-dry-run]                    # Show what leeroy would do, without doing it
                                                     # Default: true
      [--jenkins-log-level=N]                        # Detail of the messages logged by the Jenkins API client: DEBUG (0), INFO (1), WARN (2), FATAL (3)
                                                     # Default: 3
                                                     # Possible values: 0, 1, 2, 3
      [--jenkins-log-location=JENKINS_LOG_LOCATION]  # Path to write messages logged by the Jenkins API client
                                                     # Default: /dev/stdout
      [--job-regex=JOB_REGEX]                        # Regular expression to select jobs by name
                                                     # Default: .*
      [--jobs=JOBS]                                  # Path to a file containing a job name on each line
      [--password=PASSWORD]                          # Override LEEROY_JENKINS_PASSWORD
      [--server-url=SERVER_URL]                      # Override LEEROY_JENKINS_SERVER_URL
      [--threads=N]                                  # Number of threads to use for network and disk IO
                                                     # Default: 4
      [--username=USERNAME]                          # Override LEEROY_JENKINS_USERNAME

For more specific examples and documentation of features, take a look in the `features` directory (the fixtures referenced there are [here](https://github.com/Jellyvision/leeroy_jenkins/tree/master/features/fixtures)):

* [append](https://github.com/Jellyvision/leeroy_jenkins/blob/master/features/append.feature)
* [backup](https://github.com/Jellyvision/leeroy_jenkins/blob/master/features/backup.feature)
* [delete](https://github.com/Jellyvision/leeroy_jenkins/blob/master/features/delete.feature)
* [replace](https://github.com/Jellyvision/leeroy_jenkins/blob/master/features/replace.feature)
* [restore](https://github.com/Jellyvision/leeroy_jenkins/blob/master/features/restore.feature)

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake rspec` to run the unit tests. Run `bundle exec rake rubocop` to lint. You can also run `bundle exec bin/console` to launch a pry session with all code and dependencies loaded. Run `bundle exec exe/leeroy` to use the gem in this directory, ignoring other installed copies of this gem.

To run the acceptance tests, run `vagrant up` to start your own Jenkins instance. This may take 5-10 minutes, but when finished you'll be able to access Jenkins at `192.168.50.33:8080` in your web browser. Then run `bundle exec rake cucumber`. `bundle exec rake verify` will lint, run unit tests, and run acceptance tests. This is also the default rake task.
