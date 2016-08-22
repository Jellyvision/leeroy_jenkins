Feature: appending to XML nodes in jenkins jobs' config.xml

  As a jenkins administrator
  I want to use the `leeroy append` command
  So that I can append to XML nodes in jenkins jobs' config.xml

Background:
  Given I have the "cat_config.xml" fixture
  And I have the "sleepy_cat_config.xml" fixture
  And I set the environment variable "LEEROY_JENKINS_SERVER_URL" to "http://192.168.50.33:8080"

Scenario: Adding a build step to a job
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the file "new_build_step.xml" with:
    """
    <hudson.tasks.Shell>
        <command>echo &apos;Im tired&apos;
    sleep 10
    echo &apos;Im hungry&apos;</command>
    </hudson.tasks.Shell>
    """
  When I successfully run `leeroy append new_build_step.xml --job-regex cat --no-dry-run --xpath /project/builders`
  Then the "cat" job's configuration should match "sleepy_cat_config.xml"

Scenario: Dry-run
  Given the job "cat" exists with configuration from "cat_config.xml"
  And the file "new_build_step.xml" with:
    """
    <hudson.tasks.Shell>
        <command>echo &apos;Im tired&apos;
    sleep 10
    echo &apos;Im hungry&apos;</command>
    </hudson.tasks.Shell>
    """
  When I successfully run `leeroy append new_build_step.xml --job-regex cat --dry-run --xpath /project/builders`
  Then the "cat" job's configuration should match "cat_config.xml"
