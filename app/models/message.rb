class Message < ApplicationRecord
  belongs_to :user, primary_key: 'key', foreign_key: "author"
end
