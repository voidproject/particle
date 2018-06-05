require 'test_helper'
require 'uri'

class Api::PostsControllerTest < ActionDispatch::IntegrationTest
  test "post" do
    post '/api/get_home_feed'
    puts response.body

    msgkey = JSON.parse(response.body)["posts"].first["key"]

    post '/api/get_message/', params: { key: msgkey }
    puts response.body
  end
end
