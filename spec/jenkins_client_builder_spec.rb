require 'spec_helper'

describe LeeroyJenkins::JenkinsClientBuilder do
  let(:server_url) { 'http://123.123.123.123:8080' }
  let(:username) { 'user' }
  let(:password) { 'password' }
  let(:server_port) { '8080' }
  let(:log_level) { 1 }
  let(:log_location) { STDOUT }

  let(:env_server_url) { 'http://111.111.111.111:8080' }
  let(:env_username) { 'Jeff' }
  let(:env_password) { '$ecret!' }

  let(:jenkins_client) { instance_double JenkinsApi::Client }

  describe '#build' do
    context 'with jenkins server information set explicitly' do
      let(:jenkins_client_builder) { LeeroyJenkins::JenkinsClientBuilder.new server_url: server_url, username: username, password: password }

      it 'builds a jenkins client based on those settings' do
        allow(JenkinsApi::Client).to receive(:new).with(
          server_url: server_url,
          username: username,
          password: password,
          log_level: log_level,
          log_location: log_location
        ).and_return(jenkins_client)

        expect(jenkins_client_builder.build).to eql(jenkins_client)
      end
    end

    context 'with jenkins server information inferred from environment variables' do
      let(:jenkins_client_builder) { LeeroyJenkins::JenkinsClientBuilder.new }

      before do
        allow(ENV).to receive(:[]).with('LEEROY_JENKINS_SERVER_URL').and_return(env_server_url)
        allow(ENV).to receive(:[]).with('LEEROY_JENKINS_USERNAME').and_return(env_username)
        allow(ENV).to receive(:[]).with('LEEROY_JENKINS_PASSWORD').and_return(env_password)
      end

      it 'builds a jenkins client based on those settings' do
        allow(JenkinsApi::Client).to receive(:new).with(
          server_url: env_server_url,
          username: env_username,
          password: env_password,
          log_level: log_level,
          log_location: log_location
        ).and_return(jenkins_client)

        expect(jenkins_client_builder.build).to eql(jenkins_client)
      end
    end
  end
end
