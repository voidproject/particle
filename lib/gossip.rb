class Gossip

  # todo: move `Message.last.try(:id) || 0` to redis
  # todo: move `User.where('updated > ?', latest).pluck(:key, :seq).to_h` to redis
  # todo: redis based monotonic clock
  # todo: message request pagination
  # todo: sync topic from the best peer
  # todo: sync range to -1 (latest)
  # todo: handle out-of-order message and duplicate message
  # todo: handle disordered message
  # todo: reconnect most recent active peers
  # todo: keep user `updated`
  # todo: track following list concisely
  # todo: resolve host and port correctly
  # todo: add bt tracker
  # todo: peer exchange

  def initialize(key, host = nil, port = nil)
    @key, @host, @port = key, host, port
    @local_key, @local_host, @local_port = ENV['PARTICLE_ID'], ENV['PARTICLE_HOST'], ENV['PARTICLE_SYNCPORT']
  end

  def send_data(cmd, data)
    result = RestClient.post("http://#{@host}:#{@port}/api/gossip/#{cmd}", data)
    JSON.parse(result.body, :symbolize_names => true)
  end

  def connect()
    unless peer = Peer.find_by(key: @key, host: @host, port: @port)
      peer = Peer.create(key: @key, host: @host, port: @port, is_client: true)
    end
    send_data('connect', {key: @local_key, host: @local_host, port: @local_port})
  end

  def self.on_connect(key, host, port)
    if peer = Peer.find_by(key: key)
      peer.update(port: port, host: host, state_change: get_time)
    else
      peer = Peer.create(key: key, port: port, host: host, is_client: false, state_change: get_time)
    end
    {result: 'ok'}
  end

  def sync_vector_clocks()
    peer = Peer.find_by(key: @key)

    remote_latest = peer.remote_latest
    local_latest = peer.local_latest
    peer.local_latest = Message.last.try(:id) || 0
    local_clocks = User.where('updated >= ?', local_latest).pluck(:key, :seq).to_h
    result = send_data('sync_vector_clocks', {key: ENV['PARTICLE_ID'], clocks: local_clocks, latest: remote_latest, remote_latest: peer.local_latest})
    peer.remote_latest = result[:latest]
    peer.state_change = Time.now

    if peer.state.is_a? String
      peer.state = {}
    end
    remote_clocks = result[:clocks]
        remote_clocks.map { |k, v|
      if peer.state[k]
        peer.state[k][:clock] = v
      else
        peer.state[k] = {
          clock: v,
          local_mode: false,
          remote_mode: false,
          last_remote_request: 0,
          last_local_request: 0
        }
      end
    }

    peer.save
  end

  def on_sync_vector_clocks(remote_clocks, latest = 0, remote_latest = 0)
    peer = Peer.find_by(key: @key)
    new_local_latest = Message.last.try(:id) || 0
    local_clocks = User.where('updated >= ?', latest).where(key: remote_clocks.keys).pluck(:key, :seq).to_h
    peer.local_latest = latest
    peer.remote_latest = remote_latest

    peer.state_change = Time.now
    if peer.state.is_a? String
      peer.state = {}
    end
    remote_clocks.map { |k, v|
      if peer.state[k]
        peer.state[k]["clock"] = v.to_i
      else
        peer.state[k] = {
          "clock" => v.to_i,
          "local_mode" => false,
          "remote_mode" => false,
          "last_remote_request" => 0,
          "last_local_request" => 0
        }
      end
    }

    peer.save

    { clocks: local_clocks, latest: new_local_latest }
  end

  def request_message
    peer = Peer.find_by(key: @key)

    local_clocks = User.where(key: peer.state.keys).pluck(:key, :seq).to_h
    notes = {}
    peer.state.map { |key, topic|
      if topic["clock"] > local_clocks[key]
        notes[key] = {from: local_clocks[key], to: topic["clock"]}
      end
    }
    result = send_data('request_message', {key: @local_key, notes: notes})

    result[:results].each do |topickey, messages|
      messages.each do |msg|
        # todo : verify message
        add_message(msg)
      end
    end

    resp = {}
    result[:requests].each do |topickey, note|
      msgs = Message.where(author: key, seq: (note[:from].to_i)..(note[:to].to_i)).order('seq asc').all
      resp[key] = msgs
    end
    if resp.is_present?
      result = send_data('receive_message', {key: @local_key, msgs: resp})
    end

  end

  def on_request_message(notes)
    results = {}
    notes.each do |key, note|
      msgs = Message.where(author: key, seq: (note[:from].to_i)..(note[:to].to_i)).order('seq asc').all
      results[key] = msgs
    end

    peer = Peer.find_by(key: @key)
    local_clocks = User.where(key: peer.state.keys).pluck(:key, :seq).to_h
    requests = {}
    peer.state.map { |key, topic|
      if topic["clock"].to_i > local_clocks[key]
        requests[key] = {from: local_clocks[key], to: topic["clock"]}
      end
    }

    resp = { results: results, requests: requests }
  end

  def on_receive_message(notes)
    
    notes.each do |topickey, messages|
      messages.each do |msg|
        # todo : verify message
        add_message(msg)
      end
    end

  end

  def self.ping
    send_data('ping')
  end

  def on_ping
    { result: 'pong' }
  end

end
