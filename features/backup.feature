Feature: backing up jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy backup` command
  So that I can backup jenkins jobs' config.xml

Background:
  And I have the "cat_config.xml" fixture
  And I have the "dog_config.xml" fixture
  And I have the "frog_config.xml" fixture
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Backing up a job's config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  When I successfully run `leeroy backup foo/bar/backups --job-regex cat --no-dry-run`
  Then the "cat" job's configuration should match "foo/bar/backups/cat.xml"
  And the file "foo/bar/backups/dog.xml" should not exist

Scenario: Backing up all jobs' config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  When I successfully run `leeroy backup my/backup/configs --no-dry-run`
  Then the "cat" job's configuration should match "my/backup/configs/cat.xml"
  And the "dog" job's configuration should match "my/backup/configs/dog.xml"
  And the "frog" job's configuration should match "my/backup/configs/frog.xml"

Scenario: Backing up jobs' config.xml by providing a list of job names
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  And a file named "jobs_to_backup.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy backup my/backup/configs --jobs jobs_to_backup.txt --no-dry-run`
  Then the "cat" job's configuration should match "my/backup/configs/cat.xml"
  And the "dog" job's configuration should match "my/backup/configs/dog.xml"
  And a file named "my/backup/configs/frog.xml" should not exist

Scenario: Backup up jobs' config.xml by specifying a regex and a list of jobs names
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  And a file named "jobs_to_backup.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy backup my/backup/configs --jobs jobs_to_backup.txt --job-regex .+og --no-dry-run`
  Then the "dog" job's configuration should match "my/backup/configs/dog.xml"
  And a file named "my/backup/configs/frog.xml" should not exist
  And a file named "my/backup/configs/cat.xml" should not exist

Scenario: Dry-run
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  When I successfully run `leeroy backup foo/bar/backups --job-regex cat --dry-run`
  Then the file "foo/bar/backups/dog.xml" should not exist
  And the file "foo/bar/backups/cat.xml" should not exist
