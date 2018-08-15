class Event < ApplicationRecord
  belongs_to :user
  has_many :logs

  enum state: [:scheduled, :active, :cancelled]
end
