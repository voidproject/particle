class Contact < ApplicationRecord
  belongs_to :source_user, class_name: 'User', primary_key: 'key', foreign_key: "source"
  belongs_to :target_user, class_name: 'User', primary_key: 'key', foreign_key: "target"
end
