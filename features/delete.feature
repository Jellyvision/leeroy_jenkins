Feature: deleting XML nodes in jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy delete` command
  So that I can delete XML nodes in jenkins jobs' config.xml

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Removing a shell task from a job
  Given the job "cat" exists with configuration from "cat_config.xml"
  When I successfully run `leeroy delete --xpath "//command[text()='echo meow']/.." --job-regex cat --no-dry-run`
  Then the "cat" job's configuration should match "default_config.xml"

Scenario: Dry-run
  Given the job "cat" exists with configuration from "cat_config.xml"
  When I successfully run `leeroy delete --xpath "//command[text()='echo meow']/.." --job-regex cat --dry-run`
  Then the "cat" job's configuration should match "cat_config.xml"
