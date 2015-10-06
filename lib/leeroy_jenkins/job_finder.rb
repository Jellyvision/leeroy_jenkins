module LeeroyJenkins
  class JobFinder
    attr_reader :regex, :jenkins_client

    def initialize(regex, jenkins_client)
      @regex = regex
      @jenkins_client = jenkins_client
    end

    def find_jobs
      jenkins_client.job.list regex
    end
  end
end
