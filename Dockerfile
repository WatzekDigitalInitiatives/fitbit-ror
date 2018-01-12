FROM ruby:2.4

# install nodejs runtime
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs

# install app
COPY . /usr/src/walklc
WORKDIR /usr/src/walklc
RUN bundle install

# configure app
ENV RAILS_ENV production
ENV DEVISE_SECRET_KEY "$(rake secret)"
ENV SECRET_KEY_BASE "$(rake secret)"

# run
EXPOSE 3000
CMD ["rails", "s"]
