class Team < ActiveRecord::Base
  validates :name, :presence => true
  has_attached_file :avatar, styles: { thumb: '100x100#', preview: '955x300#' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 5.megabytes

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams
end
