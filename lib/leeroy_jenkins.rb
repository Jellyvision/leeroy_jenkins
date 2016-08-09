require 'jenkins_api_client'
require 'thor'
require 'nokogiri'
require 'parallel'

require 'leeroy_jenkins/version'
require 'leeroy_jenkins/cli'
require 'leeroy_jenkins/result'
require 'leeroy_jenkins/job_finder'
require 'leeroy_jenkins/jenkins_client_builder'
require 'leeroy_jenkins/job_updater'
require 'leeroy_jenkins/job_backupper'
require 'leeroy_jenkins/job_restorer'

module LeeroyJenkins
  def self.invalid_xml_document?(raw_xml)
    begin
      Nokogiri::XML(raw_xml, &:strict)
    rescue Nokogiri::XML::SyntaxError => e
      return e
    end

    false
  end
end
