module LeeroyJenkins
  # TODO: this isn't what a builder is
  class JenkinsClientBuilder
    attr_reader :server_url, :username, :password, :log_level, :log_location

    def initialize(options = {})
      @server_url = options[:server_url] || ENV['LEEROY_JENKINS_SERVER_URL']
      @username = options[:username] || ENV['LEEROY_JENKINS_USERNAME']
      @password = options[:password] || ENV['LEEROY_JENKINS_PASSWORD']

      @log_level = options[:log_level] || 1
      @log_location = options[:log_location] || STDOUT
    end

    def build
      JenkinsApi::Client.new server_url: server_url,
                             username: username,
                             password: password,
                             log_level: log_level,
                             log_location: log_location
    end
  end
end
