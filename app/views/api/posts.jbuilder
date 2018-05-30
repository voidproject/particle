json.posts @posts do |post|
  json.partial! '/api/post', post: post
end
