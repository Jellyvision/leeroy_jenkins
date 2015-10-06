require 'aruba/cucumber'
require 'jenkins_api_client'
require 'nokogiri'

JENKINS_CLIENT = JenkinsApi::Client.new server_ip: '192.168.50.33', log_level: 3, log_location: STDOUT

Aruba.configure do |config|
  config.command_search_paths << 'exe'
end

Before do
  JENKINS_CLIENT.job.delete_all!
end
