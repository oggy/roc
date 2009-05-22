Before do
  @app = CommandRat::Session.new
  @app.env = {'PATH' => File.expand_path("#{PROJECT_ROOT}/spec/mock-bin")}
end

After do
  @session.should receive_no_more_output
  @session.should receive_no_more_errors
end

When /^I run "(.*)"$/ do |command|
  @session.run command
end

When /^I enter "(.*)"$/ do |input|
  @session.enter input
end

When /^I answer "(.*)" with "(.*)"$/ do |prompt, input|
  @session.answer prompt, :with => input
end

Then /^the app should prompt "(.*)"$/ do |output|
  @session.should receive_prompt(output)
end

Then /^the app should output "(.*)"$/ do |string|
  @session.should receive_output("#{string}\n")
end

Then /^the app should output:$/ do |string|
  @session.should receive_output(string)
end

Then /^the app should error "(.*)"$/ do |string|
  @session.should receive_error("#{string}\n")
end

Then /^the app should error:$/ do |string|
  @session.should receive_error(string)
end

Then /^the app should exit with status (\d+)$/ do |status|
  @session.exit_status.should == status
end
