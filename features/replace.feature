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

Scenario: Dry-run
  Given the job "cat" exists with configuration from "cat_config.xml"
  When I successfully run `leeroy replace default_config.xml --job-regex cat --dry-run`
  Then the "cat" job's configuration should match "cat_config.xml"

Scenario: Overwriting 2 out of 3 jobs' config.xml
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  When I successfully run `leeroy replace default_config.xml --job-regex .+og --no-dry-run`
  Then the "cat" job's configuration should match "cat_config.xml"
  And the "dog" job's configuration should match "default_config.xml"
  And the "frog" job's configuration should match "default_config.xml"

Scenario: Updating part of job's config.xml by providing an XPath
  Given the job "default" exists with configuration from "default_config.xml"
  And the file "new_builders.xml" with:
    """
    <builders>
        <hudson.tasks.Shell>
            <command>echo meow</command>
        </hudson.tasks.Shell>
    </builders>
    """
  When I successfully run `leeroy replace new_builders.xml --job-regex default --no-dry-run --xpath /project/builders`
  Then the "default" job's configuration should match "cat_config.xml"

Scenario: Overwritting jobs' config.xml by providing a list of job names
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  And a file named "jobs_to_update.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy replace default_config.xml --jobs jobs_to_update.txt --no-dry-run`
  Then the "cat" job's configuration should match "default_config.xml"
  And the "dog" job's configuration should match "default_config.xml"
  And the "frog" job's configuration should match "frog_config.xml"

Scenario: Overwriting a job's config.xml by specifying a regex and a list of jobs names
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the job "dog" exists with configuration from "dog_config.xml"
  And the job "frog" exists with configuration from "frog_config.xml"
  And a file named "jobs_to_update.txt" with:
    """
    cat
    dog
    """
  When I successfully run `leeroy replace default_config.xml --jobs jobs_to_update.txt --job-regex .+og --no-dry-run`
  Then the "cat" job's configuration should match "cat_config.xml"
  And the "dog" job's configuration should match "default_config.xml"
  And the "frog" job's configuration should match "frog_config.xml"
