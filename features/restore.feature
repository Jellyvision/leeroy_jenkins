Feature: restoring jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy restore` command
  So that I can restore jenkins jobs' config.xml from backups

Background:
  Given I have the "default_config.xml" fixture
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And the directory "foo/backups"
  And I copy the file "default_config.xml" to "foo/backups/default.xml"
  And I copy the file "cat_config.xml" to "foo/backups/cat.xml"
  And I copy the file "dog_config.xml" to "foo/backups/dog.xml"

Scenario: Creating jobs from backups
  When I successfully run `leeroy restore --server-url http://192.168.50.33:8080 --backup-dir foo/backups --no-dry-run`
  Then the "cat" job's configuration should match "cat_config.xml"
  And the "dog" job's configuration should match "dog_config.xml"
  And the "default" job's configuration should match "default_config.xml"

Scenario: Overriding existing jobs' configurations
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "default" exists with configuration from "default_config.xml"
  And I move the file "foo/backups/cat.xml" to "foo/backups/dog.xml"
  And I move the file "foo/backups/default.xml" to "foo/backups/cat.xml"
  When I successfully run `leeroy restore --server-url http://192.168.50.33:8080 --backup-dir foo/backups --no-dry-run`
  Then the "cat" job's configuration should match "default_config.xml"
  And the "dog" job's configuration should match "cat_config.xml"
  And the "default" job's configuration should match "default_config.xml"
