require "test_helper"

describe Api::GossipController do

  test "gossip" do
    create_data

    akeys = {:curve=>"ed25519", :public=>"To2Qx7zeHi8WEKRNixo9-inFVzZaYSrIlLtk4ek5oGY~ed25519", :prvkey=>"gF8sxtMKy4WCstSXT6uwzhck4pNsN6RbWy-iJivyJOg~ed25519", :id=>"@To2Qx7zeHi8WEKRNixo9-inFVzZaYSrIlLtk4ek5oGY~ed25519"}
    bkeys = {:curve=>"ed25519", :public=>"Oyzfr49vwAWuJK0eQtd-jXXbqpM9zIWa95KBLOnbTd4~ed25519", :prvkey=>"D9vJCDk35-vRKknn17HQWj5akILuSiZsjlplzYED2Fk~ed25519", :id=>"@Oyzfr49vwAWuJK0eQtd-jXXbqpM9zIWa95KBLOnbTd4~ed25519"}
    
    post '/api/gossip/connect', params: { key: bkeys[:public], port: 5001, host: 'localhost' }
    puts response.body
    p Peer.last.state_change.to_f

    sleep 0.1
    post '/api/gossip/ping', params: { key: bkeys[:public] }
    puts response.body
    p Peer.last.state_change.to_f


    post '/api/gossip/sync_vector_clocks', params: { key: bkeys[:public], clocks: { akeys[:id] => 0 }, latest: 0, remote_latest: 0 }
    puts response.body

    post '/api/gossip/request_message', params: { key: bkeys[:public], notes: { akeys[:id] => { from: 0, to: 3 } } }
    puts response.body


  end

  def create_data
    akeys = {:curve=>"ed25519", :public=>"To2Qx7zeHi8WEKRNixo9-inFVzZaYSrIlLtk4ek5oGY~ed25519", :prvkey=>"gF8sxtMKy4WCstSXT6uwzhck4pNsN6RbWy-iJivyJOg~ed25519", :id=>"@To2Qx7zeHi8WEKRNixo9-inFVzZaYSrIlLtk4ek5oGY~ed25519"}
    bkeys = {:curve=>"ed25519", :public=>"Oyzfr49vwAWuJK0eQtd-jXXbqpM9zIWa95KBLOnbTd4~ed25519", :prvkey=>"D9vJCDk35-vRKknn17HQWj5akILuSiZsjlplzYED2Fk~ed25519", :id=>"@Oyzfr49vwAWuJK0eQtd-jXXbqpM9zIWa95KBLOnbTd4~ed25519"}

    alice = User.find_or_create_by(key: akeys[:id], prvkey: akeys[:prvkey], pubkey: akeys[:public], name: "alice")
    bob = User.find_or_create_by(key: bkeys[:id], prvkey: bkeys[:prvkey], pubkey: bkeys[:public], name: "bob")

    aid = akeys[:id]
    bid = bkeys[:id]

    alice.reload
    msg = publish_post(akeys, "hello1", "test", nil, alice.seq, alice.previous, get_time)
    add_message(msg)

    alice.reload
    msg = publish_post(akeys, "hello2", "test", nil, alice.seq, alice.previous, get_time)
    add_message(msg)

    alice.reload
    msg = publish_post(akeys, "hello3", "test", nil, alice.seq, alice.previous, get_time)
    add_message(msg)
  end

end
