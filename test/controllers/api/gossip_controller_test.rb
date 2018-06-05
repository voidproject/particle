require "test_helper"

describe Api::GossipController do

  test "gossip" do
    p User.count
    p Message.count
    alice = users(:alice)
    bob = users(:bob)
    cat = users(:cat)

    post '/api/gossip/connect', params: { key: bob.key, port: 5001, host: 'localhost' }
    puts response.body
    p Peer.last.state_change.to_f

    sleep 0.1
    post '/api/gossip/ping', params: { key: bob.key }
    puts response.body
    p Peer.last.state_change.to_f


    post '/api/gossip/sync_vector_clocks', params: { key: bob.key, clocks: { alice.key => 0 }, latest: 0, remote_latest: 0 }
    puts response.body

    post '/api/gossip/request_message', params: { key: bob.key, notes: { alice.key => { from: 0, to: 3 } } }
    puts response.body
  end

end
