class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string   :key
      t.string   :sig
      t.string   :author
      t.integer  :seq, default: 0
      t.string   :previous
      t.bigint   :timestamp
      t.bigint   :localtime
      t.string   :msgtype
      t.text     :raw
      t.jsonb    :content, default: '{}'
      t.integer  :subposts_count, default: 0
      t.integer  :votes_count, default: 0
      t.boolean  :blocked, default: false
      t.string   :channel
      t.string   :root
      t.datetime :created_at, null: false
    end
  end
end
