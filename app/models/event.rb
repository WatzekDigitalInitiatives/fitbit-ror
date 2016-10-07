class Event < ActiveRecord::Base
    validates :name, :start_date, :start_location, :end_location, :createdby, presence: true
    validates_length_of :description, maximum: 200
    has_attached_file :avatar, styles: { thumb: '100x100#', preview: '955x300#' }
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 5.megabytes
    has_many :user_events, dependent: :destroy
    has_many :users, through: :user_events

    attr_accessor :static_map_preview
end
