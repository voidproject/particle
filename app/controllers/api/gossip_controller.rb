class Api::GossipController < ApplicationController

  def broadcast
    ActionCable.server.broadcast 'room_channel', content:  'content'
    render json: 'ok'
  end

  def connect
    ret = Peer.on_connect(params[:key], params[:port], params[:host])
    render json: ret
  end

  def ping
    ret = Peer.on_ping
    render json: ret
  end

  def sync_vector_clocks
    clocks = 
      begin
        params.require(:clocks).permit!.to_h
      rescue Exception => e
        {}
      end
    ret = Peer.on_sync_vector_clocks(params[:key], clocks, params[:latest].to_i, params[:remote_latest].to_i)
    render json: ret
  end

  def request_message
    params.permit(:key, :notes)
    ret = Peer.on_request_message(params[:key], params[:notes] || [])
    render json: ret
  end

  def receive_message
    ret = gossip.on_receive_message(params[:key], params[:msgs] || [])
    render json: ret
  end

end

