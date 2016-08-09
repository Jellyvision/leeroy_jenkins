module LeeroyJenkins
  class JobRestorer
    attr_reader :backup_dir, :jenkins_client, :threads

    def initialize(jenkins_client, backup_dir, threads)
      @jenkins_client = jenkins_client
      @backup_dir = backup_dir
      @threads = threads
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
         .map { |file_name| "#{backup_dir}/#{file_name}" }
    end
  end
end
