# Generated by the protocol buffer compiler.  DO NOT EDIT!

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "Message" do
    optional :author, :string, 1
    optional :seq, :int64, 2
    optional :timestamp, :int64, 3
    optional :previous, :string, 4
    optional :type, :string, 5
    optional :content, :bytes, 6
  end
  add_message "Post" do
    optional :title, :string, 1
    optional :text, :string, 2
    optional :channel, :string, 3
    optional :root, :string, 4
    optional :branch, :string, 5
    optional :mentions, :string, 6
    optional :recps, :string, 7
  end
  add_message "Contact" do
    optional :contact, :string, 1
    optional :following, :bool, 2
    optional :blocking, :bool, 3
  end
  add_message "Vote" do
    optional :link, :string, 1
    optional :value, :int64, 2
    optional :reason, :string, 3
  end
  add_message "About" do
    optional :about, :string, 1
    optional :name, :string, 2
    optional :image, :string, 3
  end
end

MessageProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("Message").msgclass
PostProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("Post").msgclass
ContactProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("Contact").msgclass
VoteProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("Vote").msgclass
AboutProto = Google::Protobuf::DescriptorPool.generated_pool.lookup("About").msgclass


