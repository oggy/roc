Before do
  @rolodex_path = "#{temp_directory}/rolodex"
end

After do
  FileUtils.rm_f @rolodex_path
end

Given /^I don\'t have a rolodex$/ do
  @rolodex = nil
end

Given /^I have a rolodex with password "(.*)"$/ do |password|
  @rolodex = Roc::Rolodex.create(@rolodex_path, password)
end

Given /^I have a card "([^\"]*)"$/ do |card_name|
  @rolodex[card_name] = '...'
  @rolodex.save
end

Given /^I have a card "([^\"]*)" with content:$/ do |card_name, content|
  @rolodex[card_name] = content
  @rolodex.save
end
