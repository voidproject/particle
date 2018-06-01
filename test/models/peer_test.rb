require "test_helper"

describe Peer do
  let(:peer) { Peer.new }

  it "must be valid" do
    value(peer).must_be :valid?
  end
end
