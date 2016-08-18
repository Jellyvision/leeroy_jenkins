module LeeroyJenkins
  class JobRestorer
    attr_reader :backup_dir, :jenkins_client, :threads, :job_names, :job_regex

    def initialize(jenkins_client, backup_dir, threads, job_names, job_regex)
      @jenkins_client = jenkins_client
      @backup_dir = backup_dir
      @threads = threads
      @job_names = job_names
      @job_regex = Regexp.new(job_regex)
    end

    def dry_run
      pairs = Parallel.map(config_xml_file_paths, in_threads: threads) do |xml_path|
        job_name = File.basename(xml_path, '.*')
        [job_name, File.read(xml_path)]
      end

      Hash[pairs]
    end

    def restore!
      pairs = Parallel.map(config_xml_file_paths, in_threads: threads) do |xml_path|
        job_name = File.basename(xml_path, '.*')

        http_status_code = jenkins_client.job.create_or_update(
          job_name, File.read(xml_path)
        )

        [job_name, http_status_code]
      end

      Hash[pairs]
    end

    private

    def config_xml_file_paths
      Dir.entries(backup_dir)
         .select { |file_name| file_name.end_with? '.xml' }
         .select { |file_name| restore_job?(file_name) }
         .map { |file_name| "#{backup_dir}/#{file_name}" }
    end

    def restore_job?(file_name)
      # http://rubular.com/r/UxTupLRyg4
      job_name = file_name.match(/^(?<job_name>[^.]+)\.xml$/)['job_name']

      if job_names.any?
        job_names.include?(job_name) && job_name =~ job_regex
      else
        job_name =~ job_regex
      end
    end
  end
end
