Feature: backing up jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy backup` command
  So that I can backup jenkins jobs' config.xml

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Backing up a job's config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  When I successfully run `leeroy backup foo/bar/backups --job-regex cat`
  Then the "cat" job's configuration should match "foo/bar/backups/cat.xml"
  And the file "foo/bar/backups/dog.xml" should not exist

Scenario: Backing up all jobs' config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "default" exists with configuration from "default_config.xml"
  When I successfully run `leeroy backup my/backup/configs`
  Then the "cat" job's configuration should match "my/backup/configs/cat.xml"
  And the "dog" job's configuration should match "my/backup/configs/dog.xml"
  And the "default" job's configuration should match "my/backup/configs/default.xml"
