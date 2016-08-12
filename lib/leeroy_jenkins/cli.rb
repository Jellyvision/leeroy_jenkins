module LeeroyJenkins
  class Cli < Thor
    # exit non-zero on failure
    # https://github.com/erikhuda/thor/issues/244
    def self.exit_on_failure?
      true
    end

    class_option :dry_run,              type: :boolean, default: true,   desc: 'Write XML to STDOUT instead of to Jenkins'
    class_option :jenkins_log_level,    type: :numeric, default: 3,      desc: 'Detail of the messages logged by the Jenkins API client: DEBUG (0), INFO (1), WARN (2), FATAL (3)', enum: [0, 1, 2, 3]
    class_option :jenkins_log_location, type: :string,  default: STDOUT, desc: 'Path to write messages logged by the Jenkins API client'
    class_option :job_regex,            type: :string,  default: '.*',   desc: 'Regular expression to select jobs by name'
    class_option :jobs,                 type: :string,                   desc: 'Path to a file containing a job name on each line'
    class_option :password,             type: :string,                   desc: 'Override LEEROY_JENKINS_PASSWORD'
    class_option :server_url,           type: :string,                   desc: 'Override LEEROY_JENKINS_SERVER_URL'
    class_option :threads,              type: :numeric, default: 4,      desc: 'Number of threads to use for network and disk IO'
    class_option :username,             type: :string,                   desc: 'Override LEEROY_JENKINS_USERNAME'

    desc 'append NEW_NODE.xml', 'Append to XML nodes in jenkins jobs\' config.xml'
    option :xpath, type: :string, default: '/', desc: 'XPath of node(s) to modify in the config.xml of the specified job(s)'
    def append(new_node_path)
      raw_xml_string = File.read(new_node_path)
      xml_parse_error = LeeroyJenkins.invalid_xml_document?(raw_xml_string)
      die("#{new_node_path} does not contain well-formed XML: #{xml_parse_error}") if xml_parse_error

      puts update_jobs(raw_xml_string, __method__)
    end

    desc 'replace NEW_NODE.xml', 'Replace XML nodes in jenkins jobs\' config.xml'
    option :xpath, type: :string, default: '/', desc: 'XPath of node(s) to modify in the config.xml of the specified job(s)'
    def replace(new_node_path)
      raw_xml_string = File.read(new_node_path)
      xml_parse_error = LeeroyJenkins.invalid_xml_document?(raw_xml_string)
      die("#{new_node_path} does not contain well-formed XML: #{xml_parse_error}") if xml_parse_error

      puts update_jobs(raw_xml_string, __method__)
    end

    desc 'delete', 'Delete XML nodes in jenkins jobs\' config.xml'
    option :xpath, type: :string, default: '/', desc: 'XPath of node(s) to modify in the config.xml of the specified job(s)'
    def delete
      puts update_jobs('', __method__)
    end

    desc 'backup BACKUP_DIR_PATH', 'Save the config.xml of Jenkins jobs to disk, BACKUP_DIR created if it does not exist'
    def backup(backup_dir)
      # TODO: dry_run
      JobBackupper.new(job_names, jenkins_client, backup_dir, options[:threads]).backup
    end

    desc 'restore BACKUP_DIR_PATH', 'Restore config.xml files to Jenkins jobs from backups'
    def restore(backup_dir)
      # TODO: dry_run
      job_restorer = JobRestorer.new(jenkins_client, backup_dir, options[:threads])
      result = options[:dry_run] ? job_restorer.dry_run : job_restorer.restore!

      puts result
    end

    private

    def update_jobs(raw_xml_string, command_name)
      job_updater = JobUpdater.new(job_names, raw_xml_string, jenkins_client, options[:xpath], command_name, options[:threads])
      job_updater.update_jobs(options[:dry_run])
    end

    def jenkins_client
      @jenkins_client ||= JenkinsClientBuilder.new(
        server_url: options[:server_url],
        username: options[:username],
        password: options[:password],
        log_level: options[:jenkins_log_level],
        log_location: options[:jenkins_log_location]
      ).build
    end

    def job_names
      @job_rows ||= options[:jobs] ? File.read(options[:jobs]).split("\n") : []
      @job_names ||= JobFinder.new(jenkins_client).find_jobs(options[:job_regex], @job_rows)
    end

    def die(error_message)
      error error_message
      exit 1
    end
  end
end
