class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

    devise :omniauthable, omniauth_providers: [:fitbit]

    has_many :identities, dependent: :destroy
    has_many :user_events, dependent: :destroy
    has_many :events, through: :user_events

    attr_reader :avatar_remote_url
    has_attached_file :avatar
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

    def self.from_omniauth(auth)
        identity = Identity.where(provider: auth.provider, uid: auth.uid).first_or_create do |identity|
            if identity.user.nil?
                user = User.new
                user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.generated"
                user.password = Devise.friendly_token[0, 20]
                user.name = auth['info']['display_name']
                user.hexcolor = '#' + '%06x' % (rand * 0xffffff)
                if auth.info.image.present?
                    avatar_url = process_uri(auth.info.image)
                    user.update_attribute(:avatar, URI.parse(avatar_url))
                end
            end
            identity.user = user
        end

        identity.access_token = auth['credentials']['token']
        identity.refresh_token = auth['credentials']['refresh_token']
        identity.expires_at = auth['credentials']['expires_at']
        identity.timezone = auth['info']['timezone']
        identity.save
        identity.user
   end

    def identity_for(provider)
        identities.where(provider: provider).first
    end

    def fitbit_client
        fitbit_identity = identities.where(provider: 'fitbit').first
        FitgemOauth2::Client.new(
            token: fitbit_identity.access_token,
            client_id: ENV['FITBIT_CLIENT_ID'],
            client_secret: ENV['FITBIT_CLIENT_SECRET'],
            user_id: fitbit_identity.uid
        )
     end

    private

    def self.process_uri(uri)
        require 'open-uri'
        require 'open_uri_redirections'
        open(uri, allow_redirections: :safe) do |r|
            r.base_uri.to_s
        end
    end
end
