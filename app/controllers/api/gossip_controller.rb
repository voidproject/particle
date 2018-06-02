class Api::GossipController < ApplicationController

  def broadcast
    ActionCable.server.broadcast 'room_channel', content:  'content'
    render json: 'ok'
  end

  def connect
    Gossip.on_connect(params[:key], params[:port], params[:host])

    render json: {
      key: ENV['PARTICLE_ID'],
      host: ENV['PARTICLE_HOST'],
      port: ENV['PARTICLE_SYNCPORT'],
    }
  end

  def ping
    Peer.find_by(key: params[:key]).update(state_change: get_time)
    render json: { result: 'ok' }
  end

  def sync_vector_clocks
    clocks = params.require(:clocks).permit!.to_h
    gossip = Gossip.new(params[:key])
    ret = gossip.on_sync_vector_clocks(clocks, params[:latest].to_i, params[:remote_latest].to_i)
    render json: ret
  end

  def request_message
    params.permit(:key, :notes)
    gossip = Gossip.new(params[:key])
    ret = gossip.on_request_message(params[:notes] || [])
    render json: ret
  end

  def receive_message
    gossip = Gossip.new(params[:key])
    ret = gossip.on_receive_message(params[:msgs] || [])
    render json: ret
  end

end

