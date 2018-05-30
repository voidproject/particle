require 'test_helper'
require 'uri'

class Api::PostsControllerTest < ActionDispatch::IntegrationTest
  test "post" do
    get '/api/posts'
    puts response.body

    msgkey = JSON.parse(response.body)["posts"].first["key"]

    get '/api/posts/' + URI.escape(msgkey)
    puts response.body
  end
end
