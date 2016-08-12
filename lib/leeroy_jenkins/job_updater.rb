module LeeroyJenkins
  class JobUpdater
    attr_reader :job_names_to_update,
                :new_xml,
                :jenkins_client,
                :xpath,
                :at_xpath,
                :threads

    def initialize(job_names_to_update, new_xml, jenkins_client, xpath, at_xpath, threads)
      @job_names_to_update = job_names_to_update
      @new_xml = new_xml
      @jenkins_client = jenkins_client
      @xpath = xpath
      @at_xpath = at_xpath
      @threads = threads
    end

    def update_jobs(dry = true)
      dry ? dry_run : update_jobs!
    end

    private

    def update_jobs!
      pairs = Parallel.map(job_names_to_update, in_threads: threads) do |job_name|
        http_status_code = jenkins_client.job.post_config job_name, build_xml(job_name)
        [job_name, http_status_code]
      end

      Hash[pairs]
    end

    def dry_run
      pairs = Parallel.map(job_names_to_update, in_threads: threads) do |job_name|
        [job_name, build_xml(job_name)]
      end

      Hash[pairs]
    end

    def build_xml(job_name)
      element_to_insert = Nokogiri.XML(new_xml).root
      document_to_modify = Nokogiri.XML(current_xml(job_name), &:noblanks)
      elements_to_modify = document_to_modify.xpath(xpath).map do |node|
        node.document? ? node.root : node
      end

      elements_to_modify.each do |node|
        case at_xpath
        when :replace
          node.replace element_to_insert
        when :append
          node << element_to_insert
        when :delete
          node.remove
        end
      end

      document_to_modify.canonicalize
    end

    def current_xml(job_name)
      jenkins_client.job.get_config(job_name)
    end
  end
end
