module LeeroyJenkins
  class JobBackupper
    attr_reader :job_names_to_backup, :backup_dir, :jenkins_client, :threads

    def initialize(job_names_to_backup, jenkins_client, backup_dir, threads)
      @job_names_to_backup = job_names_to_backup
      @jenkins_client = jenkins_client
      @backup_dir = backup_dir
      @threads = threads
    end

    def job_configs
      pairs = map_job_configs do |job_name, job_config|
        [job_name, job_config]
      end

      Hash[pairs]
    end

    def backup
      FileUtils.mkdir_p(backup_dir) unless Dir.exist?(backup_dir)

      map_job_configs do |job_name, job_config|
        File.write "#{backup_dir}/#{job_name}.xml", job_config
      end
    end

    private

    def map_job_configs
      Parallel.map(job_names_to_backup, in_threads: threads) do |job_name|
        job_config = jenkins_client.job.get_config job_name
        yield job_name, job_config
      end
    end
  end
end
