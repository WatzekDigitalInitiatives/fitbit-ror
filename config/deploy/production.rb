set :stage, :production

server "34.193.153.8", user: 'ubuntu', roles: %w{app web db}
