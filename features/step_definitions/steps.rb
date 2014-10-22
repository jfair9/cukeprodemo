require 'win32ole'
require 'jruby-win32ole'
env = $props.get_env('environment')



# Launch a webpage using Selenium-Webdriver instance
# Example: Given I launch the <em>HomePage</em>
# Params:
# @page_name - name of the page to launch. Must also match an entry in the properties.xml file
When /^I launch the (.*)$/ do   |page_name|

  env = $props.get_env('environment')
  latency = $props.get_env('latency').to_i

  $gExpWindowHandle=0
  $gCurrentHandle = 0
  $gWinHandles = Array.new

  # if $props.get_env(page_name<<env).nil?
  #   assert false, "Properties.xml file did not contain a setting for #{page_name<<env}"
  # end

  if $props.get_env('browser') == ':firefox'
    Selenium::WebDriver::Firefox.path = $props.get_env('FFLocation')
    $serverff = Selenium::WebDriver.for(:firefox,:profile=>$props.get_env('FFProfile'))
    $serverff.manage.timeouts.implicit_wait = latency
    $serverff.get $props.get_env(page_name<<env)

    $browser = $serverff
    $ff_windowhandle = $browser.window_handle
    $browser.switch_to.window($browser.window_handle)
    #$browser.execute_script(" return window.focus(true)")
    $browser.execute_script('focus(true)')
    $browser.find_element(:tag_name => 'body').click

    $global_windowhandle = $ff_windowhandle
  end

  if $props.get_env('browser') == ':chrome'
    $serverch = Selenium::WebDriver.for :chrome, :switches => %w[--user-data-dir=C:\chromeProfile\SeleniumP]
    # To set up a Chrome profile cache directory: in Run, run: "chrome.exe --user-data-dir=C:\chromeProfile\SeleniumP"
    # In Chrome Advanced Settings / Downloads section - Check the box that will ask where to save each file before downloading
    $serverch.manage.timeouts.implicit_wait = latency
    $serverch.get $props.get_env(page_name<<env)

    $browser = $serverch
    $ch_windowhandle = $browser.window_handle
    $browser.switch_to.window($browser.window_handle)
    $browser.execute_script('focus(true)')
    $browser.find_element(:tag_name => 'body').click

    $global_windowhandle = $ch_windowhandle
  end

  if $props.get_env('browser') == ':ie'
    if system(File.expand_path('../app_support', File.dirname(__FILE__)) + '/ProtectedFixLinks.bat')
      puts 'Protected mode bat file executed - profit!'
    else
      puts '-_-  Human...your protected mode bat file bombed - failure!'
    end
    $serverie = Selenium::WebDriver.for(:ie)
    $serverie.manage.timeouts.implicit_wait = latency
    # $serverie.SetCapability("unexpectedAlertBehaviour", "accept")

    $serverie.get $props.get_env(page_name<<env)

    begin
      $browser = $serverie
      $ie_windowhandle = $browser.window_handle

    rescue Selenium::WebDriver::Error::UnhandledAlertError
      puts 'rescued an expected modal window for local dev environment'
    end
    $global_windowhandle = $ie_windowhandle
  end

  begin
    $gWinHandles[$gCurrentHandle] = $ie_windowhandle
    $gExpWindowHandle = $gExpWindowHandle+1
      #$gCurrentHandle= $gCurrentHandle+1
  rescue Selenium::WebDriver::Error::UnhandledAlertError
    puts 'rescued an expected modal window for local dev environment'
  end
end


# # Complete an action on the object of a page
# # Example: When I <em>click</em> <em>Login</em> on <em>LoginPage</em>
# # Params:
# # @action - name of the action. click; double_click; check; uncheck; clear
# # @object - name of the object. Must also match an entry in the mappings.xml file
# # @page - name of the page. Must also match an entry in the mappings.xml file
# # When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
 When /^I blahblah (.*) (.*) on (.*)$/ do |action, object, page|
   $props.makes('action'=>action, 'object'=>object, 'page'=>page)
 end

# Complete the double click action on the object of a page
# Example: When I <em>double_click</em> <em>Login</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
When /^I double_click (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'double_click', 'object'=>object, 'page'=>page)
end

# Complete the clear action on the object of a page
# Example: When I <em>clear</em> <em>Login</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
When /^I clear (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'clear', 'object'=>object, 'page'=>page)
end

# Complete the check action on the object of a page
# Example: When I <em>check</em> <em>AZ CheckBox</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
When /^I check (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'check', 'object'=>object, 'page'=>page)
end

# Complete the uncheck action on the object of a page
# Example: When I <em>uncheck</em> <em>AZ CheckBox</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
When /^I uncheck (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'uncheck', 'object'=>object, 'page'=>page)
end

# Complete the click action on the object of a page
# Example: When I <em>click</em> <em>Login</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# When /^I ([a-zA-Z_]+) (.*) on (.*)$/ do |action, object, page|
When /^I click (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'click', 'object'=>object, 'page'=>page)
end


# Complete the multiple_select action with values ( delimited by * ) on the object of a page
# Example: Given I multiple_select <em>"AZ * CA"</em> in <em>State CheckBoxes</em> of <em>Registration_Page</em>
# Params:
# @value - value to use with action  (delimited by *).
# @object - name of the object (list boxes that are capable of multiSelect or checkboxes). Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When(/^I multiple_select "(.*)" in (.*) of (.*)$/) do | value, object, page|
  $props.makes('action'=>'multiple_select', 'value'=>value, 'object'=>object, 'page'=>page)
end



# Complete the type action with a value on the object of a page
# Example: Given I type <em>"Jesse"</em> in <em>First_Name</em> of <em>Registration_Page</em>
# Params:
# @value - value to use with action.
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When(/^I type "(.*)" in (.*) of (.*)$/) do | value, object, page|
  # value = eval "Userdata.#{object.downcase}"
  $props.makes('action'=>'type', 'value'=> value, 'object'=>object, 'page'=>page)
end

# Complete the append action with a value on the object of a page
# Example: Given I append <em>"Fair"</em> in <em>Name</em> of <em>Registration_Page</em>
# Params:
# @value - value to use with action.
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When(/^I append "(.*)" in (.*) of (.*)$/) do | value, object, page|
  $props.makes('action'=>'append', 'value'=>value, 'object'=>object, 'page'=>page)
end


# Complete the select action with a value on the object of a page
# Example: Given I select <em>"Jesse"</em> in <em>First_Name</em> of <em>Registration_Page</em>
# Params:
# @value - value to use with action.
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When(/^I select "(.*)" in (.*) of (.*)$/) do | value, object, page|
  $props.makes('action'=>'select', 'value'=>value, 'object'=>object, 'page'=>page)
end

# Test that a value is present in an object
# Example: Then I should see <em>"Jesse"</em> text in <em>First_Name</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should see "(.*)" text in (.*) of (.*)/ do |value, object, page|
  $props.makes('object'=>object, 'page'=>page, 'action'=>'waituntil', 'value'=> value)
end

# Test that a value is not present in an object
# Example: Then I should not see <em>"Jesse"</em> text in <em>First_Name</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should not see "(.*)" text in (.*) of (.*)/ do |value, object, page|
  $props.makes('action'=>'valuenotpresent', 'value'=>value, 'object'=>object, 'page'=>page)
end

# Test that an object is not present on the page
# Example: I should not see <em>First_Name</em> object on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should not see (.*) object on (.*)/ do |object, page|
  $props.makes('action'=>'objectnotexist', 'object'=>object, 'page'=>page)
end

# Test that an object is present on the page
# Example: I should see <em>First_Name</em> object on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should see (.*) object on (.*)/ do |object, page|
  $props.makes('action'=>'object_exists', 'object'=>object, 'page'=>page)
end

# Test that an object is enabled on the page
# Example: I should see the <em>AZ CheckBox</em> object enabled on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object enabled on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'enabled', 'object' => object, 'page'=> page)
end

# Test that an object is disabled on the page
# Example: I should see the <em>AZ CheckBox</em> object disabled on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object disabled on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'disabled', 'object' => object, 'page'=> page)
end

# Test that an object is unchecked on the page
# Example: I should see the <em>AZ CheckBox</em> object unchecked on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object unchecked on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'unchecked', 'object' => object, 'page'=> page)
end

# Test that an object is checked on the page
# Example: I should see the <em>AZ CheckBox</em> object checked on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object checked on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'checked', 'object' => object, 'page'=> page)
end

# Test that an object is hidden on the page
# Example: I should see the <em>AZ CheckBox</em> object hidden on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object hidden on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'hidden', 'object' => object, 'page'=> page)
end

# Test that an object is not hidden on the page
# Example: I should see the <em>AZ CheckBox</em> object not hidden on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object not hidden on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'not hidden', 'object' => object, 'page'=> page)
end

# Test that an object is selected on the page
# Example: I should see the <em>AZ Radio Button</em> object selected on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object selected on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'selected', 'object' => object, 'page'=> page)
end

# Test that an object is unselected on the page
# Example: I should see the <em>AZ Radio Button</em> object unselected on <em>Registration_Page</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see the ([^"]*) object unselected on ([^"]*)$/ do |object, page|
  $props.makes('action'=>'validateobjstate', 'value'=> 'unselected', 'object' => object, 'page'=> page)
end

# <b>DEPRECATED:</b> Step will soon be retired. Please find an alternate step definition to use.
# Test that a value is present in an object -- usually select lists / drop downs
# Example: Then I should see <em>"Jesse"</em> value in <em>States Drop Down</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should see "(.*)" value in (.*) of (.*)/ do |value, object, page|
  $props.makes('action'=>'validateselectedvalue', 'value'=>value, 'object'=>object, 'page'=>page)
end

# Test that a value is selected in an object --  for select lists / drop downs
# Example: Then I should see <em>"Jesse"</em> value selected in <em>States Drop Down</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should see "(.*)" value selected in (.*) of (.*)/ do |value, object, page|
  $props.makes('action'=>'validateselectedvalue', 'value'=>value, 'object'=>object, 'page'=>page)
end

# Test that a value is contained in an object --  for select lists / drop downs
# Example: Then I should see <em>"Jesse"</em> contained in <em>States Drop Down</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should see "([^"]*)" contained in ([^"]*) of ([^"]*)$/ do |value, object, page|
  $props.makes('action'=>'list_contains', 'value'=> value, 'object' => object, 'page'=> page)
end

# Test that a value is not contained in an object --  for select lists / drop downs
# Example: Then I should not see <em>"Jesse"</em> contained in <em>States Drop Down</em> of <em>Registration_Page</em>
# Params:
# @value - value to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I should not see "([^"]*)" contained in ([^"]*) of ([^"]*)$/ do |value, object, page|
  $props.makes('action'=>'list_not_contains', 'value'=> value, 'object' => object, 'page'=> page)
end

# Test that a value is present on the screen
# Example: Then I should see <em>"Welcome"</em> text on the screen
# Params:
# @value - value to use. Keywords that are available: Remembered Value ....
Then /I should see "(.*)" text on the screen/ do |value|
  $props.makes('action'=>'text_exists', 'object'=> 'body', 'page'=> 'Global', 'value' => value)
end

# Test that a value is not present on the screen
# Example: Then I should not see <em>"Welcome"</em> text on the screen
# Params:
# @value - value to use. Keywords that are available: Remembered Value ....
Then /^I should not see "([^"]*)" text on the screen$/ do |value|
  $props.makes('action'=>'text_not_exists', 'object'=> 'body', 'page'=> 'Global', 'value' => value)
end


# Test that the exact list of values are contained in a list item object  --  for select lists / drop downs
# Example: Then I should see the following values in <em>Numbers Drop Down</em> of <em>Registration_Page</em>
# """
# 1
# 2
# """
# Params:
# @values - table of values to use. Keywords that are available: Blank; Remembered Value ....
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /I should see the following values in ([^"]*) of ([^"]*)/ do |object, page, values|
  $props.makes('action'=>'validatelist', 'value'=>values, 'object'=>object, 'page'=>page)
end

# Test that the table list of values are contained in a list item object  --  for select lists / drop downs
# Example: Then I should see the following contained in <em>Numbers Drop Down</em> of <em>Registration_Page</em>
# | 1 |
# | 2 |
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# @table - Gherkin inline table of expected values
Then /^I should see the following contained in ([^"]*) of ([^"]*):$/ do |object, page, table|
  # table is a | ak-test2  |pending
  table.raw.each do |table_rows|
    $props.makes('action'=>'list_contains', 'value'=> table_rows[0], 'object' => object, 'page'=> page)
  end
end

# Test that the table list of values are not contained in a list item object  --  for select lists / drop downs
# Example: Then I should not see the following contained in <em>Numbers Drop Down</em> of <em>Registration_Page</em>
# | 1 |
# | 2 |
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
# @table - Gherkin inline table of expected values
Then /^I should not see the following contained in ([^"]*) of ([^"]*):$/ do |object, page, table|

  table.raw.each do |table_rows|
    $props.makes('action'=>'list_not_contains', 'value'=> table_rows[0], 'object' => object, 'page'=> page)
  end
end

# Test the contents of an entire table - diff between gherkin inline table and html table --  for html tables
# Example: Then I should see the following values in <em>States</em> table on <em>Registration_Page</em>:
# | exp States | Available |
# | AZ         | Yes       |
# | CA         | Yes       |
# | FL         | No       |
#
# Params:
# @values - table of values to diff.
# @object - name of the HTML object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /^I should see the following values in (.*) table on (.*):$/ do |object, page, table|
  html_table = $props.makes('object'=>object, 'page'=>page, 'action'=>'gettablevalues')
  html_table.map! { |t| t.flatten}
  html_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '').strip } }
  table.diff!(html_table)
end

# Test the contents of a particular row in a table - diff between gherkin inline table and html table --  for html tables
# Example: Then I should see the following values in <em>States</em> row on <em>Registration_Page</em>:
# | exp States | Available |
# | FL         | No       |
#
# Params:
# @values - table of values to diff.
# @object - name of the HTML object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then /^I should see the following values in (.*) row on (.*):$/ do |object, page, table|
  html_table = $props.makes('object'=>object, 'page'=>page, 'action'=>'getrowvalues')

  row_table = table.raw[0], html_table

  # #row_table = ['col1','col2','col3','col4','col5','col6','col7'], html_table
  #
  # row_table = html_table
  # #TODO: change the above line to accommodate a dynamic number of columns
  row_table.map! { |r| r.map! { |c| c.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '').gsub(/^\s+/, '') } }
  table.diff!(row_table)

end



# Close the active browser window
# Example: Then I close browser
# Params:
Given /I close browser/ do
  case $props.get_env('browser')
    when ':firefox'
      $serverff.close
      $serverff.quit
    when ':ie'
      # $serverie.exit
      $serverie.quit
    when ':chrome'
      $serverch.close
      $serverch.quit
    else
      assert false, 'Browser type not supported!!'
  end
end

# Complete the clear_selected action on the object of a page. This will clear all selected values in a select list
# Example: When I clear_selected <em>States List</em> on <em>LoginPage</em>
# Params:
# @object - name of the object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I clear_selected (.*) on (.*)$/ do |object, page|
  $props.makes('action'=>'clear_selected', 'object'=>object, 'page'=>page)
end


# Test the contents of a drop down list - diff between gherkin inline table and drop down list --  for drop down list
# Example: Then I should see the following selected in <em>States DropDown</em> of <em>Registration_Page</em>:
# | FL         |
#
# Params:
# @values - table of values to diff.
# @object - name of the HTML object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
Then(/^I should see the following selected in (.*) of (.*):$/) do |object, page, table|
  # table is a table.hashes.keys # => []
  #TODO: add capability to validate that a table of values is selected in a multi select list box
  # table.raw.each do |table_rows|
  table.hashes
  # $props.makes('action'=>'compare_selected_values', 'value'=>table.hashes, 'object'=>object, 'page'=>page)
  selected_values = $props.makes('action'=>'compare_selected_values', 'object'=>object, 'page'=>page)
  assert_empty table.raw.flatten - selected_values , "Expected items selected was not as expected. Delta's were #{selected_values - table.raw.flatten}"
  # end
end

Then(/^I should not see the following selected in (.*) of (.*):$/) do |object, page, table|
  # table is a table.hashes.keys # => []
  pending
  #TODO: add capability to validate that a table of values is not selected in a multi select list box
  table.each { |value|

  }
end

# Test for the text to exist in a modal window
# Example: I should see "Password Required" text in Modal Window
#
# Params:
# @value - value to assert
Then /I should see "(.*)" text in Modal Window/ do |value|
  modal_alert_text = $browser.switch_to.alert.text
  modal_alert_text=modal_alert_text.gsub(/<.+?>/, '').gsub(/[\n\t\r]/, '')

  assert modal_alert_text == value, "Text in Modal Window not as expected. Expected '#{value}' but actual text was '#{modal_alert_text}'"
end

# Test for the text to exist in a modal window
# Example: I should see "Password Required" text in Modal Window
#
# Params:
# @value - value to assert
When /^I ([^"]*) the confirmation$/ do |value|
  alert=$browser.switch_to.alert

  if value.downcase == 'accept'
    alert.accept
  else
    alert.dismiss
  end

end


# Switch to a new window / html page
# Example: When I switch to new window
#
# Params:
When /^I switch to new window$/ do
  if $browser.window_handles.size != $gWindowHandleSize.to_i+1
    def wait_for_window(timeout=5000)
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      wait.until {$browser.window_handles.size==$gWindowHandleSize.to_i+1}
    end
  end
  begin
    $browser.switch_to.window($gWinHandles[$gCurrentHandle])
  rescue Selenium::WebDriver::Error::UnhandledAlertError
    puts "Recovering from Modal Window Issue"
  end
end

# Switch to a previous window / html page
# Example: When I switch to previous window
#
# Params:
When /^I switch to previous window$/ do

  #$gWinHandles.delete($gCurrentHandle)
  $gWinHandles.delete_at($gCurrentHandle)

  $gExpWindowHandle = $gExpWindowHandle-1
  $gCurrentHandle =  $gCurrentHandle-1

  begin
    $browser.switch_to.window($gWinHandles[$gCurrentHandle])
  rescue Selenium::WebDriver::Error::NoSuchWindowError
    $browser.switch_to.window($browser.window_handles.last)
  end
end


# Dynamically remember values and store in a global variable slots for later use
# Dynamic values can be used throughout all step's by passing "Remembered Value"; "Remembered Second Value";...
# Example 1: I remember the value1 in UserName of Login_Page -- stores in global variable slot 1
# Example 2: I remember the value2 in UserName of Login_Page -- stores in global variable slot 2
#
# Params:
# @num - number appended to to the keyword 'value' to distinguish between other dynamically stored values
# @object - name of the HTML object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When /^I remember the value(.*) in ([^"]*) of ([^"]*)$/ do |num, object, page|
  if num == ''
    num = 1
  end
  eval "$global_var#{num} = $props.makes('object'=>object, 'page'=>page, 'action'=>'get_value')"
  # $global_var1 = $props.makes('object'=>object, 'page'=>page, 'action'=>'get_value')
end


# Used to send text to the browser on focused element
# Example: When I send the "HELLO" text
#
# value: value to send
When /^I send the "([^"]*)" text$/ do |value|
  $browser.keyboard.send_keys value
end


# Dynamically remember values and store in a user defined global variable for later use
# Dynamic values can be used throughout all step's by passing "Stored MyVariable"; "Stored YourVariable";...
# Example 1: I store the value as "MyVariable" from Last_Name of SampleForm
# Example 2: I store the value as "YourVariable" from Last_Name of SampleForm
#
# Params:
# @num - number appended to to the keyword 'value' to distinguish between other dynamically stored values
# @object - name of the HTML object. Must also match an entry in the mappings.xml file
# @page - name of the page. Must also match an entry in the mappings.xml file
When(/^I store the value as "([^"]*)" from (.*) of (.*)/) do |var, object, page|
  eval "$#{var} = $props.makes('object'=>object, 'page'=>page, 'action'=>'get_value')"
end

And(/^my "([^"]*)" data is:$/) do |data, table|

  $current_data_set = data
   eval "#{data} = FactoryGirl.build(:#{data.downcase}, :default, #{table.hashes[0]})"

end

When(/^I enter my (.*) into (.*)$/) do |object, page|
  value = eval "#{$current_data_set}.#{object.downcase}"
  $props.makes('action'=>'type', 'value'=> value, 'object'=>object, 'page'=>page)
end

Then(/^I should see the correct value in (.*) of (.*)$/) do |object, page|
  value = eval "#{$current_data_set}.#{object.downcase}"
  $props.makes('object'=>object, 'page'=>page, 'action'=>'waituntil', 'value'=> value)
end

And(/^I am using the (.*) "([^"]*)"$/) do |data_type, data|
  $current_data_set = data
  eval "#{data} = FactoryGirl.build(:#{data.downcase}, :#{data_type})"
end

When(/^I fillout (.*) with (.*)$/) do |page, data|

  fill_out_form(page, eval("#{data}"))

end
