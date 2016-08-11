Feature: replacing XML nodes in jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy replace` command
  So that I can replace XML nodes in jenkins jobs' config.xml

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And I have the "frog_config.xml" fixture
  And I have the "sleepy_cat_config.xml" fixture
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Overwriting a job's config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  When I successfully run `leeroy replace default_config.xml --job-regex cat --no-dry-run`
  Then the "cat" job's configuration should match "default_config.xml"
