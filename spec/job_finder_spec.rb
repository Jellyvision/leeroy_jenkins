require 'spec_helper'

describe LeeroyJenkins::JobFinder do
  let(:regex) { '.*' }
  let(:jenkins_client) { instance_double JenkinsApi::Client, job: job_client }
  let(:job_client) { instance_double JenkinsApi::Client::Job }
  let(:all_jobs) { %w(job_1 job_2 job_3) }
  let(:some_jobs) { %w(job_1 job_2) }

  let(:job_finder) { LeeroyJenkins::JobFinder.new(jenkins_client) }

  describe '#find_jobs' do
    context 'with a regex' do
      it 'returns an array of job names that match the regex' do
        allow(job_client).to receive(:list).with(regex).and_return(all_jobs)
        expect(job_finder.find_jobs(regex)).to eql(all_jobs)
      end
    end

    context 'with a regex and a jobs array' do
      it 'returns an array of job names that match the regex and are in the array' do
        allow(job_client).to receive(:list).with(regex).and_return(all_jobs)
        expect(job_finder.find_jobs(regex, some_jobs)).to eql(some_jobs)
      end
    end
  end
end
