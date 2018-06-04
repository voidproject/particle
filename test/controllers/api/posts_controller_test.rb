require 'test_helper'
require 'uri'

class Api::PostsControllerTest < ActionDispatch::IntegrationTest
  test "post" do
    create_data

    post '/api/get_home_feed'
    puts response.body

    msgkey = JSON.parse(response.body)["posts"].first["key"]

    post '/api/get_message/', params: { key: msgkey }
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
