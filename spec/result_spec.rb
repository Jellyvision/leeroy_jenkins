require 'spec_helper'

describe LeeroyJenkins::Result do
  describe '#to_s' do
    context 'with an array of job hashes' do
      context 'with job_name and status_code' do
        let(:result_hashes) do
          [
            { job_name: 'job_1', status_code: 200 },
            { job_name: 'job_2', status_code: 400 },
            { job_name: 'job_3', status_code: 403 }
          ]
        end

        let(:expected) do
          <<EOF
---
- :job_name: job_1
  :status_code: 200
- :job_name: job_2
  :status_code: 400
- :job_name: job_3
  :status_code: 403
EOF
        end

        it 'returns a readable representation' do
          actual = LeeroyJenkins::Result.new(result_hashes).to_s
          expect(actual).to eq(expected)
        end
      end

      context 'with job_name and new_xml' do
        let(:result_hashes) do
          [
            { job_name: 'job_1', new_xml: '<newXML>foo</newXML>' },
            { job_name: 'job_2', new_xml: '<newXML>bar</newXML>' },
            { job_name: 'job_3', new_xml: '<newXML>baz</newXML>' }
          ]
        end

        let(:expected) do
          <<EOF
---
- :job_name: job_1
  :new_xml: "<newXML>foo</newXML>"
- :job_name: job_2
  :new_xml: "<newXML>bar</newXML>"
- :job_name: job_3
  :new_xml: "<newXML>baz</newXML>"
EOF
        end

        it 'returns a readable representation' do
          actual = LeeroyJenkins::Result.new(result_hashes).to_s
          expect(actual).to eq(expected)
        end
      end
    end
  end
end
