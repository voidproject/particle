require 'rbnacl'
require 'base64'
require 'json'
require 'google/protobuf'
require "#{Rails.root}/lib/message_schema.proto"

def sha256(data)
  RbNaCl::Hash.sha256(data)
end

def randombytes(n=32)
  RbNaCl::Random.random_bytes(n)
end

def generate_key(seed=nil)
  if seed
    prvkey = RbNaCl::SigningKey.new(seed)
  else
    prvkey = RbNaCl::SigningKey.generate()
  end

  pubkey = Base64.urlsafe_encode64(prvkey.verify_key.to_bytes).gsub('=','') + '~ed25519'
  prvkey = Base64.urlsafe_encode64(prvkey.to_bytes).gsub('=','') + '~ed25519'
  id = '@' + pubkey

  {
    curve: 'ed25519',
    public: pubkey,
    prvkey: prvkey,
    id: id
  }
end

def sign_data(prvkey, data)
  prvkey = prvkey.sub('~ed25519', '')
  prvkey = Base64.urlsafe_decode64(prvkey)
  prvkey = RbNaCl::SigningKey.new(prvkey)
  Base64.urlsafe_encode64(prvkey.sign(data)).gsub('=','') + '~sig~ed25519'
end


def verify_data(pubkey, data, signed)
  pubkey = pubkey.sub('~ed25519', '')
  pubkey = Base64.urlsafe_decode64(pubkey)
  pubkey = RbNaCl::VerifyKey.new(pubkey)

  signed = Base64.urlsafe_decode64(signed.sub('~sig~ed25519', ''))
  pubkey.verify(signed, data)
end

def verify_hash(pubkey, data, signed)
  pubkey = pubkey.sub('@', '').sub('~ed25519', '')
  pubkey = Base64.urlsafe_decode64(pubkey)
  pubkey = RbNaCl::VerifyKey.new(pubkey)

  data = data.sub('%', '').sub('~sha256', '')
  data = Base64.urlsafe_decode64(data)
  
  signed = Base64.urlsafe_decode64(signed.sub('~sig~ed25519', ''))
  pubkey.verify(signed, data)
end

def verify_message(message)
  message.symbolize_keys
  key = message[:key]
  author = message[:author]
  item = message[:content].compact
  case message[:type]
  when 'post'
    item_data = PostProto.encode(PostProto.new(item))
  when 'contact'
    item_data = ContactProto.encode(ContactProto.new(item))
  when 'vote'
    item_data = VoteProto.encode(VoteProto.new(item))
  when 'about'
    item_data = AboutProto.encode(AboutProto.new(item))
  end

  data = {
    author: message[:author],
    timestamp: message[:timestamp],
    seq: message[:seq],
    previous: message[:previous],
    type: message[:type],
    content: item_data,
  }
  data = MessageProto.encode(MessageProto.new(data.compact))

  verify_hash(message[:author], message[:key], message[:sig])
end

def encode_message(keys, msg)
  author = msg[:author]
  content = msg[:content].compact
  proto_schema = case msg[:type]
  when "post"
    PostProto
  when "contact"
    ContactProto
  when "vote"
    VoteProto
  when "about"
    AboutProto
  else
    nil
  end

  data = proto_schema.encode(proto_schema.new(content))
  data = {
    author: msg[:author],
    timestamp: msg[:timestamp],
    seq: msg[:seq],
    previous: msg[:previous],
    type: msg[:type],
    content: data,
  }
  data = MessageProto.encode(MessageProto.new(data.compact))
  msghash = sha256(data)

  pubkey = keys[:public]
  prvkey = keys[:prvkey]
  sig = sign_data(prvkey, msghash)
  key = '%' + Base64.urlsafe_encode64(msghash) + '~sha256'

  {
    sig: sig,
    key: key,
    type: msg[:type],
    content: msg[:content],
    author: msg[:author],
    seq: msg[:seq],
    previous: msg[:previous],
    timestamp: msg[:timestamp],
  }
end

def publish_message(keys, type, item, seq = 0, previous = nil, timestamp = 0)
  msg = {
    author: keys[:id],
    seq: (seq + 1),
    type: type,
    timestamp: timestamp,
    previous: previous,
    content: item.compact,
  }

  encode_message(keys, msg)
end

def publish_post(keys, title, text = '', channel = nil, seq = 0, previous = nil, timestamp = 0)
  publish_message(keys, "post", {title: title, text: text, channel: channel}, seq, previous, timestamp)
end

def add_message(msg)
  msg = msg.dup
  case
  when msg[:type] == 'post' && msg[:content][:root]
    msg[:root] = msg[:content][:root]
    rootmsg = Message.find_by(key: msg[:content][:root])
    if rootmsg
      rootmsg.increment!(:subposts_count)
    end
  when msg[:type] == 'post' && msg[:content][:channel]
    msg[:channel] = msg[:content][:channel]
  when msg[:type] == 'contact' && msg[:content][:following]
    if msg[:content][:contact] != msg[:author]
      Contact.find_or_create_by(source: msg[:author], target: msg[:content][:contact])
      # todo: should create user automatically
      source_user = User.find_by(key: msg[:author])
      taregt_user = User.find_by(key: msg[:content][:contact])
      if source_user.state == 'original' && taregt_user.blank?
        User.create(key: msg[:content][:contact], state: 'general')
      elsif source_user.state == 'original' && taregt_user.state == 'unfollowed'
        taregt_user.update(state: 'general')
      end
    end
  when msg[:type] == 'contact' && !msg[:content][:following]
    Contact.find_by(source: msg[:author], target: msg[:content][:contact]).delete
    # todo: should check user following automatically
    existed = Contact.joins(:source_user).where(users: {state: 'original'}).where(target: msg[:content][:contact]).exists?
    unless existed
      User.find_by(key: msg[:content][:contact]).update(is_following: false, state: 'unfollowed')
    end
  when msg[:type] == 'vote' && msg[:content][:value] == 1
    Vote.find_or_create_by(source: msg[:author], target: msg[:content][:link])
  when msg[:type] == 'vote' && msg[:content][:value] == 0
    Vote.find_by(source: msg[:author], target: msg[:content][:link]).delete
  when msg[:type] == 'about'
    User.find_by(key: msg[:author]).update(name: msg[:content][:name], image: msg[:content][:image])
  end

  msg[:raw] = JSON.dump(msg)
  msg[:msgtype] = msg[:type]
  msg.delete(:type)
  message = Message.create(msg)
  User.find_by(key: msg[:author]).update(seq: msg[:seq], previous: msg[:key])
  message
end

def multibox(msg, recipients)
  raise if recipients.length > 7
  nonce = randombytes(24)
  key = randombytes(32)
  onetime = keypair()
end

def openbox(msg, recipients)
  raise if recipients.length > 7
  nonce = randombytes(24)
  key = randombytes(32)
  onetime = keypair()
end

def get_time()
  (Time.now.to_f * 1000).to_i
end

