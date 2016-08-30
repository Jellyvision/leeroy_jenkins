require 'spec_helper'

describe LeeroyJenkins::JobBackupper do
  let(:job_names) { ['job_1', 'job_2', 'job_3'] }
  let(:job_1_config) { '<foo>job_1</foo>' }
  let(:job_2_config) { '<bar>job_2</bar>' }
  let(:job_3_config) { '<baz>job_3</baz>' }
  let(:jenkins_client) { instance_double(JenkinsApi::Client, job: job_client) }
  let(:job_client) { instance_double(JenkinsApi::Client::Job) }
  let(:backup_dir) { 'path/to/backups' }
  let(:threads) { 4 }
  let(:job_backupper) { LeeroyJenkins::JobBackupper.new(job_names, jenkins_client, backup_dir, threads) }
  let(:expected_result) do
    LeeroyJenkins::Result.new(
      'job_1' => "#{backup_dir}/job_1.xml",
      'job_2' => "#{backup_dir}/job_2.xml",
      'job_3' => "#{backup_dir}/job_3.xml"
    )
  end

  describe '#backup' do
    context 'dry_run = false' do
      before do
        allow(job_client).to receive(:get_config).with('job_1').and_return(job_1_config)
        allow(job_client).to receive(:get_config).with('job_2').and_return(job_2_config)
        allow(job_client).to receive(:get_config).with('job_3').and_return(job_3_config)

        expect(File).to receive(:write).with("#{backup_dir}/job_1.xml", job_1_config)
        expect(File).to receive(:write).with("#{backup_dir}/job_2.xml", job_2_config)
        expect(File).to receive(:write).with("#{backup_dir}/job_3.xml", job_3_config)
      end

      context 'backup_dir does not exist' do
        it 'creates that directory and writes the XML configs for the specified jobs to it' do
          allow(Dir).to receive(:exist?).with(backup_dir).and_return(false)
          expect(FileUtils).to receive(:mkdir_p).with(backup_dir)
          expect(job_backupper.backup(false)).to eq(expected_result)
        end
      end

      context 'backup_dir exists' do
        it 'writes the XML configs for the specified jobs to it' do
          allow(Dir).to receive(:exists?).with(backup_dir).and_return(true)
          expect(job_backupper.backup(false)).to eq(expected_result)
        end
      end
    end
  end

  context 'dry_run = true' do
    it 'returns the XML files that would be written for each job' do
      expect(job_backupper.backup(true)).to eq(expected_result)
    end
  end
end
