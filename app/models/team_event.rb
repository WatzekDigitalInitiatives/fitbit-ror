class TeamEvent < ActiveRecord::Base
  belongs_to :team
  belongs_to :event
  validates :team_id, :event_id, :presence => true
end
