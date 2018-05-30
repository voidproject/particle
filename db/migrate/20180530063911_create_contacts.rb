class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string  :source
      t.string  :target
      t.string  :type
    end
  end
end
