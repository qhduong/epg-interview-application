require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  
  test "should respond with no result if no acronym is passed" do
  	acronym = ""
  	post :search, :sf => acronym
  	assert_match(/Sorry there are no results found for: #{acronym}/, response.body)
  end

  test "should respond with no result if an invalid acronym is passed" do
  	acronym = "1nv@l1d"
  	post :search, :sf => acronym
  	assert_match(/Sorry there are no results found for: #{acronym}/, response.body)
  end

  test "should respond with a list of acronyms if a valid one is passed" do
  	acronym = "ad"
  	post :search, :sf => acronym
  	assert_select 'li'
  end

  test "should respond with no result if a limit of 0 is passed" do
  	acronym = "ad"
  	limit   = 0
  	post :search, :sf => acronym, :limit => limit
  	assert_select 'li', limit
  end

  test "should respond with 10 items if a limit of 10 is passed" do
  	acronym = "ad"
  	limit   = 10
  	post :search, :sf => acronym, :limit => limit
  	assert_select 'li', limit
  end

  test "should respond with all items if an invalid limit is given" do
  	acronym = "ad"
  	limit   = "invalid_limit"
  	post :search, :sf => acronym, :limit => limit
  	assert_select 'li'
  end
end
