class Event < ActiveRecord::Base
  validates :name, :start_date, :start_location, :end_location, :createdby, :private, :presence => true
  has_many :user_events, :dependent => :destroy
  has_many :users, through: :user_events
end
