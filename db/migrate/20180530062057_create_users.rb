class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :key
      t.string  :pubkey
      t.string  :prvkey
      t.string  :curve, default: "ed25519"
      t.integer :seq, default: 0
      t.string  :previous
      t.string  :name
      t.string  :image
      t.string  :state, default: ""
      t.integer :messages_count, default: 0
      t.integer :posts_count, default: 0
      t.integer :subposts_count, default: 0
      t.integer :votes_count, default: 0
      t.integer :following_count, default: 0
      t.integer :general_following_count, default: 0
      t.boolean :is_blocking, default: false
      t.boolean :is_following, default: true
      t.datetime :created_at, null: false
    end
  end
end
