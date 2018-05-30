json.(post, :id, :key, :sig, :author, :seq, :previous, :timestamp, :content, :subposts_count, :votes_count)
json.type post.msgtype
json.liked Vote.find_by(source: @user && @user.key, target: post.key).present?
