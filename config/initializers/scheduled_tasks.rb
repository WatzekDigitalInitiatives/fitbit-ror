require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '7h' do
  @users = User.all

  if @users

    @users.each do |user|
      fitbit_identity = user.identities.where(provider: 'fitbit').first
      token = fitbit_identity.refresh_token
      client = user.fitbit_client
      oauth_data = client.refresh_access_token(token)
      fitbit_identity.access_token = oauth_data["access_token"]
      fitbit_identity.refresh_token = oauth_data["refresh_token"]
      fitbit_identity.save
    end

  end

end
