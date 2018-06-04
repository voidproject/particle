json.(post, :id, :key, :sig, :author, :seq, :previous, :timestamp, :content)
json.type post.msgtype
json.liked !!(@user && Vote.find_by(source: @user && @user.key, target: post.key))

json.attached do
  json.(post, :subposts_count, :votes_count)

  user = post.user
  json.name user.try(:name)
  json.image user.try(:image)
end