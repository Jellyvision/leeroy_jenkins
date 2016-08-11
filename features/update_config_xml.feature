Feature: modifying jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy update-config` command
  So that I can modify jenkins jobs' config.xml

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And I have the "frog_config.xml" fixture
  And I have the "sleepy_cat_config.xml" fixture

Scenario: Removing a shell task from a job
  Given the job "cat" exists with configuration from "cat_config.xml"
  When I successfully run `leeroy update-config --job-regex cat --new-xml default_config.xml --no-dry-run  --xpath "//command[text()='echo meow']/.." --at-xpath delete`
  Then the "cat" job's configuration should match "default_config.xml"
