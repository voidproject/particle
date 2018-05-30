json.post do
  json.partial! '/api/post', post: @post
end
