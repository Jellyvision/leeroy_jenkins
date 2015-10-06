require 'spec_helper'

describe LeeroyJenkins::JobFinder do
  let(:regex) { '.*' }
  let(:jenkins_client) { instance_double JenkinsApi::Client, job: job_client }
  let(:job_client) { instance_double JenkinsApi::Client::Job }
  let(:job_names) { ['job_1', 'job_2', 'job_3'] }

  let(:job_finder) { LeeroyJenkins::JobFinder.new regex, jenkins_client }

  describe '#find_jobs' do
    it 'returns an array of job names that match the regex' do
      allow(job_client).to receive(:list).with(regex).and_return(job_names)
      expect(job_finder.find_jobs).to eql(job_names)
    end
  end
end
