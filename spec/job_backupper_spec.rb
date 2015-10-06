require 'spec_helper'

describe LeeroyJenkins::JobBackupper do
  let(:job_names) { ['job_1', 'job_2', 'job_3'] }
  let(:job_1_config) { '<foo>job_1</foo>' }
  let(:job_2_config) { '<bar>job_2</bar>' }
  let(:job_3_config) { '<baz>job_3</baz>' }
  let(:jenkins_client) { instance_double JenkinsApi::Client, job: job_client }
  let(:job_client) { instance_double JenkinsApi::Client::Job }
  let(:backup_dir) { 'path/to/backups' }
  let(:threads) { 4 }
  let(:job_backupper) { LeeroyJenkins::JobBackupper.new job_names, jenkins_client, backup_dir, threads }

  before do
    allow(job_client).to receive(:get_config).with('job_1').and_return(job_1_config)
    allow(job_client).to receive(:get_config).with('job_2').and_return(job_2_config)
    allow(job_client).to receive(:get_config).with('job_3').and_return(job_3_config)
  end

  describe '#get_job_configs' do
    context 'with 3 job names' do
      it 'returns a hash of job names and their config.xml' do
        expect(job_backupper.get_job_configs).to eql('job_1' => job_1_config, 'job_2' => job_2_config, 'job_3' => job_3_config)
      end
    end
  end

  describe '#backup' do
    before do
      expect(File).to receive(:write).with("#{backup_dir}/job_1.xml", job_1_config)
      expect(File).to receive(:write).with("#{backup_dir}/job_2.xml", job_2_config)
      expect(File).to receive(:write).with("#{backup_dir}/job_3.xml", job_3_config)
    end

    context 'backup_dir does not exist' do
      before do
        allow(Dir).to receive(:exists?).with(backup_dir).and_return(false)
        expect(FileUtils).to receive(:mkdir_p).with(backup_dir)
      end

      it('creates that directory and writes the XML configs for the specified jobs to it') { job_backupper.backup }
    end

    context 'backup_dir exists' do
      before { allow(Dir).to receive(:exists?).with(backup_dir).and_return(true) }

      it('writes the XML configs for the specified jobs to it') { job_backupper.backup }
    end
  end
end
