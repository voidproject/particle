json.(post, :id, :key, :sig, :author, :seq, :previous, :timestamp, :content)
json.type post.msgtype
json.liked Vote.find_by(source: @user && @user.key, target: post.key).present?

json.attached do
  json.(post, :subposts_count, :votes_count)

  user = User.find_by(key: post.author)
  json.name user.try(:name)
  json.image user.try(:image)
end