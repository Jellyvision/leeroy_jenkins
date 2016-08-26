module LeeroyJenkins
  class JobBackupper
    attr_reader :job_names_to_backup, :backup_dir, :jenkins_client, :threads

    def initialize(job_names_to_backup, jenkins_client, backup_dir, threads)
      @job_names_to_backup = job_names_to_backup
      @jenkins_client = jenkins_client
      @backup_dir = backup_dir
      @threads = threads
    end

    def backup(dry = true)
      Result.new(dry ? dry_run : backup!)
    end

    private

    def backup!
      FileUtils.mkdir_p(backup_dir) unless Dir.exist?(backup_dir)

      pairs = Parallel.map(job_names_to_backup, in_threads: threads) do |job_name|
        job_config = jenkins_client.job.get_config(job_name)
        path = xml_file_path(job_name)
        File.write(path, job_config)
        [job_name, path]
      end

      Hash[pairs]
    end

    def dry_run
      pairs = job_names_to_backup.map do |job_name|
        [job_name, xml_file_path(job_name)]
      end

      Hash[pairs]
    end

    def xml_file_path(job_name)
      "#{backup_dir}/#{job_name}.xml"
    end
  end
end
