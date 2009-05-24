Before do
  @session = CommandRat::Session.new
  bin = "#{project_root}/bin"
  mock_bin = "#{project_root}/spec/mock-bin"
  @session.env = {'PATH' => "#{mock_bin}:#{bin}"}
end

After do
  @session.should receive_no_more_output
  @session.should receive_no_more_output(:on => :stderr)
end

When /^I run "(.*)"$/ do |command|
  @session.run command
end

When /^I enter "(.*)"$/ do |input|
  @session.enter input
end

When /^I answer "(.*)" with "(.*)"$/ do |prompt, response|
  @session.should receive(prompt)
  @session.enter response
end

Then /^the app should prompt "(.*)"$/ do |prompt|
  @session.should receive(prompt)
end

Then /^the app should output "(.*)"$/ do |string|
  @session.should receive("#{string}\n")
end

Then /^the app should output:$/ do |string|
  @session.should receive(string)
end

Then /^the app should error "(.*)"$/ do |string|
  @session.should receive("#{string}\n", :on => :stderr)
end

Then /^the app should error:$/ do |string|
  @session.should receive_output(string, :on => :stderr)
end

Then /^the app should exit with status (\d+)$/ do |status|
  @session.exit_status.should == status
end
