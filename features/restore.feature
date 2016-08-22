Feature: restoring jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy restore` command
  So that I can restore jenkins jobs' config.xml from backups

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And the directory "backups"
  And I move the file "default_config.xml" to "backups/default.xml"
  And I move the file "cat_config.xml" to "backups/cat.xml"
  And I move the file "dog_config.xml" to "backups/dog.xml"
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Creating jobs from backups
  When I successfully run `leeroy restore backups --no-dry-run`
  Then the "cat" job's configuration should match "backups/cat.xml"
  And the "dog" job's configuration should match "backups/dog.xml"
  And the "default" job's configuration should match "backups/default.xml"

Scenario: Dry-run
  When I successfully run `leeroy restore backups --dry-run`
  Then the "dog" job should not exist
  And the "cat" job should not exist
  And the "default" job should not exist

Scenario: Overriding existing jobs' configurations
  Given the job "cat" exists with configuration from "backups/cat.xml"
  And the job "dog" exists with configuration from "backups/dog.xml"
  And the job "default" exists with configuration from "backups/default.xml"
  And I copy the file "backups/default.xml" to "backups/dog.xml"
  And I copy the file "backups/default.xml" to "backups/cat.xml"
  When I successfully run `leeroy restore backups --no-dry-run`
  Then the "cat" job's configuration should match "backups/default.xml"
  And the "dog" job's configuration should match "backups/default.xml"
  And the "default" job's configuration should match "backups/default.xml"

Scenario: Restoring jobs' config.xml by providing a list of job names
  Given a file named "jobs_to_restore.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy restore backups --jobs jobs_to_restore.txt --no-dry-run`
  Then the "cat" job's configuration should match "backups/cat.xml"
  And the "dog" job's configuration should match "backups/dog.xml"
  And the "default" job should not exist

Scenario: Restoring jobs' config.xml by specifying a regex and a list of jobs names
  Given a file named "jobs_to_restore.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy restore backups --jobs jobs_to_restore.txt --job-regex .+og --no-dry-run`
  Then the "dog" job's configuration should match "backups/dog.xml"
  And the "cat" job should not exist
  And the "default" job should not exist
