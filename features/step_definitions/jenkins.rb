# TODO: replace with https://github.com/cucumber/aruba/blob/b23f6dab56b7fdd734718b2e58a07bd578bbeaa0/lib/aruba/cucumber/file.rb#L1-L4
Given /^I have the "([^"]*)" fixture$/ do |name|
  copy File.join(aruba.config.fixtures_path_prefix, name), name
end

Given /^the job "([^"]*)" exists with configuration from "([^"]*)"$/ do |job_name, file_name|
  xml = read(file_name).join("\n")
  JENKINS_CLIENT.job.create job_name, xml
end

Then /^the "([^"]*)" job's configuration should match "([^"]*)"$/ do |job_name, file_name|
  actual_xml = format_xml JENKINS_CLIENT.job.get_config(job_name)
  expected_xml = format_xml read(file_name).join("\n")
  expect(actual_xml).to eql(expected_xml)
end

def format_xml(xml)
  Nokogiri.XML(xml, &:noblanks).canonicalize
end
