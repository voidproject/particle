class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.string  :source
      t.string  :target
    end
  end
end
