source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'omniauth-fitbit', :git => "https://github.com/rishijavia/omniauth-fitbit.git"
gem 'figaro'
gem 'materialize-sass'
gem 'gon'
gem 'paperclip', '~> 5.1.0'
gem 'aws-sdk'
gem 'open_uri_redirections'
gem 'fitgem_oauth2'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
gem 'rufus-scheduler'
gem 'puma'


group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'mailcatcher'
  gem 'byebug'
  gem 'web-console', '~> 3.0'
  gem 'spring', '1.7.2'
end

group :test do
  gem 'minitest-reporters', '1.1.11'
  gem 'mini_backtrace', '0.1.3'
  gem 'guard-minitest', '2.4.6'
end
