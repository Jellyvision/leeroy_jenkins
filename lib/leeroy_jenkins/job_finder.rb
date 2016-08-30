module LeeroyJenkins
  class JobFinder
    attr_reader :jenkins_client

    def initialize(jenkins_client)
      @jenkins_client = jenkins_client
    end

    def find_jobs(regex, job_names = [])
      jobs_matching_regex = jenkins_client.job.list(regex)

      if job_names.any?
        jobs_matching_regex.select do |job|
          job_names.include? job
        end
      else
        jobs_matching_regex
      end
    end
  end
end
