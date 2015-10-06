require 'spec_helper'

describe LeeroyJenkins::JobRestorer do
  let(:job_names) { ['job_1', 'job_2', 'job_3'] }
  let(:job_1_config) { '<foo>job_1</foo>' }
  let(:job_2_config) { '<bar>job_2</bar>' }
  let(:job_3_config) { '<baz>job_3</baz>' }
  let(:jenkins_client) { instance_double JenkinsApi::Client, job: job_client }
  let(:job_client) { instance_double JenkinsApi::Client::Job }
  let(:backup_dir) { 'path/to/backups' }
  let(:threads) { 4 }
  let(:job_restorer) { LeeroyJenkins::JobRestorer.new jenkins_client, backup_dir, threads }

  before do
    allow(Dir).to receive(:entries).with(backup_dir).and_return(['.', '..', 'job_1.xml', 'job_2.xml', 'job_3.xml'])
    allow(File).to receive(:read).with("#{backup_dir}/job_1.xml").and_return(job_1_config)
    allow(File).to receive(:read).with("#{backup_dir}/job_2.xml").and_return(job_2_config)
    allow(File).to receive(:read).with("#{backup_dir}/job_3.xml").and_return(job_3_config)
  end

  describe '#dry_run' do
    it 'returns a hash of job names and their config XML that was backed up' do
      expect(job_restorer.dry_run).to eql('job_1' => job_1_config, 'job_2' => job_2_config, 'job_3' => job_3_config)
    end
  end

  describe '#restore!' do
    it 'writes the backed up XML configs to Jenkins and returns a hash of job names and HTTP status codes' do
      expect(job_client).to receive(:create_or_update).with('job_1', job_1_config).and_return(200)
      expect(job_client).to receive(:create_or_update).with('job_2', job_2_config).and_return(200)
      expect(job_client).to receive(:create_or_update).with('job_3', job_3_config).and_return(200)

      expect(job_restorer.restore!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200)
    end
  end
end
