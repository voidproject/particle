class Api::GossipController < ApplicationController

  def broadcast
      ActionCable.server.broadcast 'room_channel', content:  'content'
      render json: 'ok'
  end

  def connect
    Peer.create(key: params[:key], port: params[:port], host: params[:host], is_client: false, state_change: get_time)

    render json: {
      key: 'alice',
      host: 'localhost',
      port: 3000,
    }
  end

  def ping
    Peer.find_by(key: params[:key]).update(state_change: get_time)

    render json: {
      key: 'alice',
      source: params[:key],
    }
  end

  def sync_vector_clocks
    peer_id = params[:key]
    remote_clocks = params[:clocks]
    local_latest = Message.last.try(:id)
    local_clocks = User.pluck(:key, :seq).to_h

    peer = Peer.find_by(key: params[:key])
    peer.state = remote_clocks

    render json: { clocks: local_clocks, latest: local_latest }
  end

  def sync_follows
    peer_id = params[:key]
    peer = Peer.find_by(key: params[:key])
    peer.state.merge(params[:clocks])
    peer.topic_latest = params[:topic_latest]
    peer.save
  end

  def pull_follows
  end

end

