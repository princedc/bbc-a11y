require 'capybara'
require 'bbc/a11y/linter'

Given(/^a standards-compliant website running at http:\/\/localhost:(\d+)$/) do |port|
  WebServer.ensure_running_on(port)
end

Given(/^all the tests pass$/) do
  WebServer.ensure_running_on(54321)
  step "I run `a11y http://localhost:54321/perfect.html`"
end

Given(/^one test fails$/) do
  WebServer.ensure_running_on(54321)
  step "I run `a11y http://localhost:54321/missing_header.html`"
end

Given(/^a page with the HTML:$/) do |string|
  @page = Capybara.string(string.to_s)
end

When(/^I validate the page$/) do
  @result = BBC::A11y::Linter.new(@page).run
end

Then(/^it passes$/) do
  expect(@result).to be_passed
end

Then(/^it fails with the message:$/) do |message|
  expect(@result).to be_failed
  expect(@result.to_s).to include message.to_s
end
