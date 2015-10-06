require 'spec_helper'

describe LeeroyJenkins::JobUpdater do
  let(:job_names) { ['job_1', 'job_2', 'job_3'] }
  let(:jenkins_client) { instance_double JenkinsApi::Client, job: job_client }
  let(:job_client) { instance_double JenkinsApi::Client::Job }
  let(:new_xml) { '<a><b>new</b></a>' }
  let(:current_xml) { '<x><y>current</y></x>' }
  let(:threads) { 4 }

  let(:job_updater) { LeeroyJenkins::JobUpdater.new job_names, new_xml, jenkins_client, xpath, at_xpath, threads }

  before do
    allow(job_client).to receive(:get_config).with(/job_\d/).and_return(current_xml)
    allow(job_client).to receive(:post_config).with(/job_\d/, constructed_xml).and_return(200)
  end

  describe '#update_jobs!' do
    context 'at_xpath = "replace"' do
      let(:at_xpath) { 'replace' }

      context 'xpath = "/"' do
        let(:xpath) { '/' }
        let(:constructed_xml) { new_xml }

        it('overwrites the existing config.xml files') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end

      context 'xpath = "/x/y"' do
        let(:xpath) { '/x/y' }
        let(:constructed_xml) { '<x><a><b>new</b></a></x>' }

        it('overwrites the specified XML nodes in the config.xml files') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end
    end

    context 'at_xpath = "append"' do
      let(:at_xpath) { 'append' }

      context 'xpath = "/"' do
        let(:xpath) { '/' }
        let(:constructed_xml) { '<x><y>current</y><a><b>new</b></a></x>' }

        it('appends to the root elements') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end

      context 'xpath = "/x/y"' do
        let(:xpath) { '/x/y' }
        let(:constructed_xml) { '<x><y>current<a><b>new</b></a></y></x>' }

        it('appends to the specified nodes in the config.xml files') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end
    end

    context 'at_xpath = "delete"' do
      let(:at_xpath) { 'delete' }

      context 'xpath = "/"' do
        let(:xpath) { '/' }
        let(:constructed_xml) { '' }

        it('deletes the root element of the specified jobs') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end

      context 'xpath = "/x/y"' do
        let(:xpath) { '/x/y' }
        let(:constructed_xml) { '<x></x>' }

        it('deletes the specified nodes in the config.xml files') { expect(job_updater.update_jobs!).to eql('job_1' => 200, 'job_2' => 200, 'job_3' => 200) }
      end
    end
  end

  describe '#dry_run' do
    context 'at_xpath = "replace"' do
      let(:at_xpath) { 'replace' }

      context 'xpath = "x/y"' do
        let(:xpath) { '/x/y' }
        let(:constructed_xml) { '<x><a><b>new</b></a></x>' }

        it 'returns a hash of job names and what their new config.xml would look like' do
          expect(job_updater.dry_run).to eql('job_1' => constructed_xml, 'job_2' => constructed_xml, 'job_3' => constructed_xml)
        end
      end
    end
  end
end
