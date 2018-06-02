class Peer < ApplicationRecord

  def local_key
    ENV['PARTICLE_ID']
  end

  def local_host
    ENV['PARTICLE_HOST']
  end

  def local_port
    ENV['PARTICLE_SYNCPORT']
  end

  def echo
    puts key
  end

  def send_data(cmd, data)
    result = RestClient.post("http://#{self.host}:#{self.port}/api/gossip/#{cmd}", data)
    JSON.parse(result.body, :symbolize_names => true)
  end

  def connect()
    unless peer = Peer.find_by(key: key, host: host, port: port)
      peer = Peer.create(key: key, host: host, port: port, is_client: true)
    end
    send_data('connect', {key: local_key, host: local_host, port: local_port})
  end

  def self.on_connect(key, host, port)
    if peer = Peer.find_by(key: key)
      peer.update(port: port, host: host, state_change: get_time)
    else
      peer = Peer.create(key: key, port: port, host: host, is_client: false, state_change: get_time)
    end

    { key: ENV['PARTICLE_ID'], host: ENV['PARTICLE_HOST'], port: ENV['PARTICLE_SYNCPORT'] }
  end

  def sync_vector_clocks()
    local_clocks = User.where('updated >= ?', self.local_latest).pluck(:key, :seq).to_h
    # update local_latest
    self.local_latest = Message.last.try(:id) || 0
    result = send_data('sync_vector_clocks', {key: ENV['PARTICLE_ID'], clocks: local_clocks, latest: self.remote_latest, remote_latest: self.local_latest})
    self.remote_latest = result[:latest]
    self.state_change = get_time

    if self.state.is_a? String
      self.state = {}
    end
    remote_clocks = result[:clocks]
        remote_clocks.map { |k, v|
      if self.state[k]
        self.state[k][:clock] = v
      else
        self.state[k] = {
          clock: v,
          local_mode: false,
          remote_mode: false,
          last_remote_request: 0,
          last_local_request: 0
        }
      end
    }

    self.save
  end

  def self.on_sync_vector_clocks(key, remote_clocks, latest = 0, remote_latest = 0)
    peer = Peer.find_by(key: key)
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
    local_clocks = User.where(key: self.state.keys).pluck(:key, :seq).to_h
    notes = {}
    self.state.map { |key, topic|
      if topic["clock"] > local_clocks[key]
        notes[key] = {from: local_clocks[key], to: topic["clock"]}
      end
    }
    result = send_data('request_message', {key: self.local_key, notes: notes})

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
      result = send_data('receive_message', {key: self.local_key, msgs: resp})
    end
  end

  def self.on_request_message(key, notes)
    results = {}
    notes.each do |key, note|
      msgs = Message.where(author: key, seq: (note[:from].to_i)..(note[:to].to_i)).order('seq asc').all
      results[key] = msgs
    end

    peer = Peer.find_by(key: key)
    local_clocks = User.where(key: peer.state.keys).pluck(:key, :seq).to_h
    requests = {}
    peer.state.map { |key, topic|
      if topic["clock"].to_i > local_clocks[key]
        requests[key] = {from: local_clocks[key], to: topic["clock"]}
      end
    }

    resp = { results: results, requests: requests }
  end

  def self.on_receive_message(key, notes)
    notes.each do |topickey, messages|
      messages.each do |msg|
        # todo : verify message
        add_message(msg)
      end
    end
  end

  def ping
    send_data('ping', {})
  end

  def self.on_ping(key)
    Peer.find_by(key: key).update(state_change: get_time)
    { result: 'pong' }
  end

end
